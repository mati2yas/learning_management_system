import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/features/exam_grade_filter/provider/exam_grade_filter_provider.dart';
import 'package:lms_system/features/exam_questions/provider/current_id_stub_provider.dart';
import 'package:lms_system/features/exam_questions/provider/exam_questions_provider.dart';
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
    final pageNavController = ref.read(pageNavigationProvider.notifier);
    examData = pageNavController.getArgumentsForPage(8);
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
                pageNavController.navigatePage(7);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            title: Text(examData["exam title"] ?? "Current Exam"),
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
                            .map(
                              (tab) => Tab(
                                height: 24,
                                text: tab,
                              ),
                            )
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
                    // Filter the gradconst es by the current tab
                    debugPrint("current tabTitle: $tabTitle");
                    print(
                        "all grades: ${grades.map((gr) => gr.title).join(",")}");
                    final selectedGrade = grades.firstWhere(
                      (grade) => grade.title == tabTitle,
                      orElse: () => ExamGrade(id: 0, title: "", chapters: []),
                    );
                    debugPrint("selected Grade: ${selectedGrade.title}");

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
                              "${chapters[index].questionsCount} questions",
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
                                  "exam course": examData["exam course"]!,
                                  "exam year": examData["exam year"]!,
                                  "questions": chapters[index].questions,
                                  "previousScreen": 8,
                                  "hasTimerOption": false,
                                };
                                ref
                                    .read(currentIdStubProvider.notifier)
                                    .changeStub(
                                  {
                                    "idType": IdType.all,
                                    "id": chapters[index].id,
                                    "courseId": examData["courseId"],
                                  },
                                );
                                ref
                                    .read(examQuestionsApiProvider.notifier)
                                    .fetchQuestions();
                                pageNavController.navigatePage(6,
                                    arguments: examDataNext);
                              },
                              child: const Text("Take"),
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
