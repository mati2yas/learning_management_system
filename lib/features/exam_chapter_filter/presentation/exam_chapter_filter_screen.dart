import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/async_error_widget.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/app_ints.dart';
import 'package:lms_system/core/constants/app_strings.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/constants/status_bar_styles.dart';
import 'package:lms_system/features/exam_chapter_filter/provider/exam_chapter_filter_provider.dart';
import 'package:lms_system/features/exam_grade_filter/provider/exam_grade_filter_provider.dart';
import 'package:lms_system/features/exam_questions/provider/current_id_stub_provider.dart';
import 'package:lms_system/features/exam_questions/provider/exam_questions_provider.dart';
import 'package:lms_system/features/exams/model/exam_year.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';

class ExamChapterFilterScreen extends ConsumerStatefulWidget {
  const ExamChapterFilterScreen({super.key});

  @override
  ConsumerState<ExamChapterFilterScreen> createState() =>
      _ExamChapterFilterState();
}

class _ExamChapterFilterState extends ConsumerState<ExamChapterFilterScreen>
    with TickerProviderStateMixin {
  Map<String, dynamic> examData = {};

  @override
  Widget build(BuildContext context) {
    final apiState = ref.watch(examChapterFilterApiProvider);
    final pageNavController = ref.read(pageNavigationProvider.notifier);
    examData = pageNavController.getArgumentsForPage(9);
    String examYearValue = "";
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

    SystemChrome.setSystemUIOverlayStyle(darkAppBarSystemOverlayStyle);
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
          data: (chapters) {
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
                          AppStrings.examCourseKey:
                              examData[AppStrings.examCourseKey]!,
                          AppStrings.examYearKey: examYearValue,
                          AppStrings.previousScreenKey: 9,
                          AppStrings.hasTimerOptionKey: false,
                        };
                        ref.read(currentIdStubProvider.notifier).changeStub(
                          {
                            AppStrings.stubIdType: IdType.filteredForChapter,
                            AppStrings.stubChapterId: chapters[index].id,
                            AppStrings.stubId: chapters[index].id,
                          },
                        );
                        ref
                            .refresh(examQuestionsApiProvider.notifier)
                            .fetchQuestions();
                        pageNavController.navigateTo(
                          nextScreen: AppInts.examQuestionsPageIndex,
                          arguments: examDataNext,
                        );
                      },
                      child: const Text("Take"),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
