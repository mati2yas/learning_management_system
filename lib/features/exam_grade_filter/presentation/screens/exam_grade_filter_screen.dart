import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/features/exam_grade_filter/provider/exam_grade_filter_provider.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';
import 'package:lms_system/features/shared/presentation/widgets/custom_tab_bar.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';

class ExamGradeFilterScreen extends ConsumerStatefulWidget {
  const ExamGradeFilterScreen({super.key});

  @override
  ConsumerState<ExamGradeFilterScreen> createState() => _ExamGradeFilterState();
}

class _ExamGradeFilterState extends ConsumerState<ExamGradeFilterScreen>
    with TickerProviderStateMixin {
  bool initializingPage = false;
  Map<String, dynamic> examData = {};
  List<String> tabsList = ["Grade 9", "Grade 10", "Grade 11", "Grade 12"];
  List<String> gradesDropDown = [];
  String currentTab = "", gradeDropDownValue = "";
  int? currentTabIndex;

  @override
  Widget build(BuildContext context) {
    final apiState = ref.watch(examGradeFilterApiProvider);
    print("Current Tab: $currentTab");
    print("exam titleee: ${examData["exam title"]}");
    final pageController = ref.read(pageNavigationProvider.notifier);
    var size = MediaQuery.of(context).size;
    var textTh = Theme.of(context).textTheme;
    return DefaultTabController(
      length: tabsList.length,
      child: Builder(builder: (context) {
        final tabController = DefaultTabController.of(context);
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {
            setState(() {
              currentTabIndex = tabController.index;
            });
          }
        });
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
            title: Text(examData["exam title"] ?? "title"),
            centerTitle: true,
            elevation: 5,
            shadowColor: Colors.black87,
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.white,
            bottom: PreferredSize(
              preferredSize: Size(size.width, 56),
              child: Container(
                width: size.width,
                color: Colors.white,
                height: 36,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      CustomTabBar(
                        alignment: TabAlignment.start,
                        isScrollable: true,
                        tabs: tabsList
                            .map((ex) => Text(
                                  ex,
                                  style: textTh.titleMedium,
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: apiState.when(
              loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.mainBlue,
                      strokeWidth: 5,
                    ),
                  ),
              error: (error, stack) => Center(
                    child: Text(
                      error.toString(),
                      style: textTh.titleMedium!.copyWith(color: Colors.red),
                    ),
                  ),
              data: (grades) {
                return TabBarView(
                  controller: tabController,
                  children: tabsList.map((tabTitle) {
                    // Filter the grades by the current tab
                    final selectedGrade = grades.firstWhere(
                      (grade) => grade.title == tabTitle,
                      orElse: () => ExamGrade(id: "", title: "", chapters: []),
                    );

                    final chapters = selectedGrade.chapters;

                    return ListView.builder(
                      itemCount: chapters.length,
                      itemBuilder: (_, index) {
                        return Card(
                          color: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(chapters[index].title),
                            subtitle: Text(
                              "${chapters[index].questions.length} questions",
                            ),
                            trailing: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.mainBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: () {
                                Map<String, dynamic> examDataNext = {
                                  //"exam title": examData["exam title"],
                                  "exam title": "exam titlee",
                                  "exam year": "year.title",
                                  "questions": chapters[index].questions,
                                  "previusScreen": 8,
                                };
                                pageController.navigatePage(6,
                                    arguments: examDataNext);
                              },
                              child: const Text("Take?"),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              }),
        );
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    // initializingPage = true;

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final pageController = ref.read(pageNavigationProvider.notifier);
    //   examData = pageController.getArgumentsForPage(8) as Map<String, dynamic>;

    //   setState(() {
    //     var yearVal = examData["exam year"]! as ExamYear;
    //     year = yearVal;
    //     var tabsSet = yearVal.grades.map((yr) => yr.title).toSet();
    //     tabsList = List.from(tabsSet);

    //     gradesDropDown = yearVal.grades.map((grade) => grade.title).toList();
    //     gradeDropDownValue = gradesDropDown.first;

    //     tabController = TabController(
    //       length: tabsList.length,
    //       vsync: this,
    //     );

    //     currentTab = tabsList[0];

    //     tabController.addListener(() {
    //       setState(() {
    //         currentTab = tabsList[tabController.index];
    //       });
    //     });
    //     initializingPage = false;
    //   });
    // });
  }
}
