import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';

import '../../../../core/constants/colors.dart';

class ExamCoursesScreen extends ConsumerStatefulWidget {
  const ExamCoursesScreen({
    super.key,
  });

  @override
  ConsumerState<ExamCoursesScreen> createState() => _ExamCoursesScreenState();
}

class _ExamCoursesScreenState extends ConsumerState<ExamCoursesScreen>
    with TickerProviderStateMixin {
  late Exam exam;
  late TabController tabController;
  List<String> tabsList = [], yearsDropDown = [];
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
          preferredSize: Size(size.width, 96),
          child: Container(
            width: size.width,
            color: Colors.white,
            height: 84,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton(
                    value: yearDropDownValue,
                    items: yearsDropDown.map((yrDr) {
                      return DropdownMenuItem(
                        value: yrDr,
                        child: Text(yrDr),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        yearDropDownValue = val!;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  if (tabController.length != 0)
                    TabBar(
                      tabAlignment: TabAlignment.start,
                      isScrollable: true,
                      tabs: tabsList
                          .map((ex) => Text(
                                ex,
                                style: textTh.titleMedium,
                              ))
                          .toList(),
                      controller: tabController,
                    ),
                ],
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

                  // Filter the years based on the selected dropdown value
                  final filteredYears = selectedCourse.years.where((year) {
                    return yearDropDownValue.isEmpty ||
                        year.title == yearDropDownValue;
                  }).toList();

                  // Build the ListView of years
                  return ListView.builder(
                    itemCount: filteredYears.length,
                    itemBuilder: (context, index) {
                      final year = filteredYears[index];
                      return ListTile(
                        title: Text(year.title),
                        subtitle: Text('${year.questions.length} questions'),
                        onTap: () {
                          // Handle year tap, e.g., navigate to details
                        },
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
            yearDropDownValue = "";
          });
        });
        initializingPage = false;
      }); // setState

      // addPostFrameCallback ends here
    });
  }
}
