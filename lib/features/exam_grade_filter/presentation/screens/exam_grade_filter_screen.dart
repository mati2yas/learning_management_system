import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/async_error_widget.dart';
import 'package:lms_system/core/common_widgets/custom_button.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/app_ints.dart';
import 'package:lms_system/core/constants/app_strings.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/constants/fonts.dart';
import 'package:lms_system/features/exam_grade_filter/provider/exam_grade_filter_provider.dart';
import 'package:lms_system/features/exam_questions/provider/current_id_stub_provider.dart';
import 'package:lms_system/features/exam_questions/provider/exam_questions_provider.dart';
import 'package:lms_system/features/exams/model/exam_year.dart';
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
    debugPrint("Current Tab: $currentTab");
    debugPrint("exam titleee: ${examData["exam title"]}");
    final pageNavController = ref.read(pageNavigationProvider.notifier);
    examData = pageNavController.getArgumentsForPage(8);
    var examYearValue;
    if (examData[AppStrings.examYearKey] != null) {
      if (examData[AppStrings.examYearKey] is ExamYear) {
        examYearValue = (examData[AppStrings.examYearKey] as ExamYear).title;
      } else if (examData[AppStrings.examYearKey] is String) {
        examYearValue = examData[AppStrings.examYearKey];
      }
    } else {
      examYearValue = "";
    }
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
                //pageNavController
                //   .navigatePage(examData[AppStrings.previousScreenKey]!);
                pageNavController.navigateBack(
                    //previousScreen: ref.read(pageNavigationProvider).nextScreen,
                    );
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            title: Text("${examData[AppStrings.examCourseKey]} $examYearValue"),
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
              error: (error, stack) => AsyncErrorWidget(
                    errorMsg: error.toString(),
                    callback: () async {
                      ref
                          .watch(examGradeFilterApiProvider.notifier)
                          .fetchExamGrades();
                    },
                  ),
              data: (grades) {
                return TabBarView(
                  controller: tabController,
                  children: tabsList.map((tabTitle) {
                    // Filter the gradconst es by the current tab
                    debugPrint("current tabTitle: $tabTitle");
                    debugPrint(
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
                            trailing: CustomButton(
                              isFilledButton: true,
                              buttonWidth: 40,
                              buttonHeight: 35,
                              buttonWidget: Text(
                                'Take',
                                style: textTheme.labelMedium!.copyWith(
                                    letterSpacing: 0.5,
                                    fontFamily: "Inter",
                                    color: Colors.white,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              buttonAction: () {
                                Map<String, dynamic> examDataNext = {
                                  //"exam title": examData["exam title"],
                                  AppStrings.examCourseKey:
                                      examData[AppStrings.examCourseKey]!,
                                  AppStrings.examYearKey:
                                      examData[AppStrings.examYearKey]!,
                                  AppStrings.questionsKey:
                                      chapters[index].questions,
                                  AppStrings.previousScreenKey: 8,
                                  AppStrings.hasTimerOptionKey: false,
                                };
                                ref
                                    .read(currentIdStubProvider.notifier)
                                    .changeStub(
                                  {
                                    AppStrings.stubIdType: IdType.filtered,
                                    AppStrings.stubId: chapters[index].id,
                                    AppStrings.stubGradeId: selectedGrade.id,
                                  },
                                );
                                ref
                                    .refresh(examQuestionsApiProvider.notifier)
                                    .fetchQuestions();
                                pageNavController.navigateTo(
                                  nextScreen: AppInts.examQuestionsPageIndex,
                                  // previousScreen:
                                  //     AppInts.examGradeFilterPageIndex,
                                  arguments: examDataNext,
                                );
                              },
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
  }
}
