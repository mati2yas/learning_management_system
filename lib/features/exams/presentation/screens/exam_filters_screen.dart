import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';
import 'package:lms_system/features/shared/presentation/widgets/custom_tab_bar.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';

import '../../../../core/constants/colors.dart';

class ExamFiltersScreen extends ConsumerStatefulWidget {
  const ExamFiltersScreen({
    super.key,
  });

  @override
  ConsumerState<ExamFiltersScreen> createState() => _ExamCoursesScreenState();
}

class _ExamCoursesScreenState extends ConsumerState<ExamFiltersScreen>
    with TickerProviderStateMixin {
  late Exam exam;
  late TabController tabController;
  List<String> tabsList = [], yearsDropDown = ["2012", "2013"];
  String currentTab = "";
  String yearDropDownValue = "";
  bool initializingPage = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var textTh = Theme.of(context).textTheme;

    final pageController = ref.read(pageNavigationProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            pageController.navigatePage(3);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(exam.title),
        centerTitle: true,
        elevation: 5,
        shadowColor: Colors.black87,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size(size.width, 26),
          child: Container(
            width: size.width,
            color: Colors.white,
            height: 24,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: CustomTabBar(
                tabs: tabsList
                    .map((ex) => Text(
                          ex,
                          style: textTh.titleMedium,
                        ))
                    .toList(),
                controller: tabController,
                alignment: TabAlignment.start,
                isScrollable: true,
              ),
            ),
          ),
        ),
      ),
      body: initializingPage
          ? const Center(
              child: SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  color: AppColors.mainBlue,
                  strokeWidth: 5,
                ),
              ),
            )
          : TabBarView(
              controller: tabController,
              children: tabsList.map(
                (tabTitle) {
                  // Find the course matching the current tab title
                  final selectedCourse = exam.courses.firstWhere(
                    (course) => course.title == tabTitle,
                    orElse: () => ExamCourse(
                      id: '',
                      title: '',
                      years: [],
                    ),
                  );

                  // removed the dropdown that filters course per year
                  // because we can just display all years
                  // in the listview
                  final unfilteredYears = selectedCourse.years;

                  // Build the ListView of years
                  return ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    itemCount: unfilteredYears.length,
                    itemBuilder: (context, index) {
                      final year = unfilteredYears[index];
                      return Card(
                        color: Colors.white,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(year.title),
                          subtitle: Text('${year.questions.length} questions'),
                          onTap: () {},
                          trailing: exam.examType == ExamType.matric
                              ? PopupMenuButton<void>(
                                  icon: const Icon(
                                      Icons.more_vert), // Vertical three dots
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<void>>[
                                    PopupMenuItem<void>(
                                      onTap: () {
                                        // navigate to the page that
                                        // shows the exam
                                        Map<String, dynamic> examData = {
                                          "exam title": exam.title,
                                          "exam year": year.title,
                                          "questions": year.questions,
                                          "previusScreen": 7,
                                        };
                                        pageController.navigatePage(6,
                                            arguments: examData);
                                      },
                                      child: const ListTile(
                                        leading: Icon(Icons.question_answer),
                                        title: Text('Take All'),
                                      ),
                                    ),
                                    PopupMenuItem<void>(
                                      onTap: () {
                                        // navigate to the page that
                                        // further filter the exams
                                        print(
                                            "to page 8, exam title: ${exam.title}");
                                        pageController.navigatePage(
                                          8,
                                          arguments: <String, dynamic>{
                                            "exam title": exam.title,
                                            "exam year": year,
                                            //"exam title": year.title,
                                          },
                                        );
                                      },
                                      child: const ListTile(
                                        leading: Icon(Icons.filter_alt),
                                        title: Text('Filter'),
                                      ),
                                    ),
                                  ],
                                )
                              : FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.mainBlue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (exam.examType == ExamType.matric) {
                                    } else {
                                      // if null then other pages, move on to
                                      // questions page
                                      Map<String, dynamic> examData = {
                                        "exam title": exam.title,
                                        "exam year": year.title,
                                        "questions": year.questions,
                                        "previusScreen": 7,
                                      };
                                      pageController.navigatePage(6,
                                          arguments: examData);
                                    }
                                  },
                                  child: const Text("Take"),
                                ),
                        ),
                      );
                    },
                  );
                },
              ).toList(),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    initializingPage = true;

    // the logic is inside this cause ref cannot be called
    // in initstate since initState runs before the widgets
    // injected into the riverpod scope, and that causes
    // an error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pageController = ref.read(pageNavigationProvider.notifier);
      exam = pageController.getArgumentsForPage(7) as Exam;

      // Extract unique years and tabs
      final Set uniqueYears = <String>{};
      final Set uniqueCourses = <String>{};
      for (var course in exam.courses) {
        uniqueCourses.add(course.title);
        for (var year in course.years) {
          uniqueYears.add(year.title);
        }
      }

      setState(() {
        var tabsSet = exam.courses.map((course) => course.title).toSet();
        print(tabsSet.join(","));
        tabsList = List.from(tabsSet);
        var yrDrops = <String>{};
        for (var course in exam.courses) {
          for (var year in course.years) {
            yrDrops.add(year.title);
          }
        }
        yearsDropDown = List.from(yrDrops);
        yearDropDownValue = yearsDropDown.first;
        // Initialize the TabController
        tabController = TabController(
          length: tabsList.length,
          vsync: this,
        );

        currentTab = tabsList[0];

        // Add listener to TabController
        tabController.addListener(() {
          setState(() {
            currentTab = tabsList[tabController.index];
            yearDropDownValue = "2012";
          });
        });
        initializingPage = false;
      }); // setState

      // addPostFrameCallback ends here
    });
  }
}
