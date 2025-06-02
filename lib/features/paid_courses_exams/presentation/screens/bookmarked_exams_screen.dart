import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/async_error_widget.dart';
import 'package:lms_system/core/common_widgets/custom_button.dart';
import 'package:lms_system/core/common_widgets/no_data_widget.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/app_ints.dart';
import 'package:lms_system/core/constants/app_strings.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/constants/fonts.dart';
import 'package:lms_system/core/utils/util_functions.dart';
import 'package:lms_system/features/exam_courses_filter/provider/current_exam_year_provider.dart';
import 'package:lms_system/features/exam_grade_filter/provider/exam_grade_filter_provider.dart';
import 'package:lms_system/features/exam_questions/provider/current_id_stub_provider.dart';
import 'package:lms_system/features/exam_questions/provider/exam_questions_provider.dart';
import 'package:lms_system/features/exams/provider/current_exam_course_id.dart';
import 'package:lms_system/features/paid_courses_exams/provider/paid_exam_provider.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';

class BookmarkedExamsScreen extends ConsumerWidget {
  const BookmarkedExamsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isWideScreen = MediaQuery.sizeOf(context).width > 600;
    final pageNavController = ref.read(pageNavigationProvider.notifier);
    var size = MediaQuery.of(context).size;
    var textTh = Theme.of(context).textTheme;

    final examsApiController = ref.watch(paidExamsApiProvider.notifier);
    final examsApiState = ref.watch(paidExamsApiProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bookmarked Exams",
          style: textTh.titleLarge!.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 5,
        shadowColor: Colors.black87,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
      ),
      body: examsApiState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: AppColors.mainBlue,
            strokeWidth: 5,
          ),
        ),
        error: (error, stack) => AsyncErrorWidget(
          errorMsg: error.toString(),
          callback: () async {
            await ref.refresh(paidExamsApiProvider.notifier).fetchPaidExams();
          },
        ),
        data: (exams) => exams.isEmpty
            ? NoDataWidget(
                noDataMsg: "No Paid Exams Yet.",
                callback: () async {
                  await ref
                      .refresh(paidExamsApiProvider.notifier)
                      .fetchPaidExams();
                },
              )
            : SizedBox(
                width: double.infinity,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  separatorBuilder: (_, index) => const SizedBox(height: 15),
                  itemCount: exams.length,
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      child: Card(
                        color: Colors.white,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: exams.isEmpty
                            ? NoDataWidget(
                                noDataMsg: "No Paid Exams Yet.",
                                callback: () async {
                                  await ref
                                      .refresh(paidExamsApiProvider.notifier)
                                      .fetchPaidExams();
                                },
                              )
                            : ListTile(
                                title: Text(exams[index].examYear),
                                subtitle: Text(exams[index].parentCourseTitle),
                                trailing: exams[index].examType ==
                                        UtilFunctions()
                                            .getExamStringValue(ExamType.matric)
                                    ? PopupMenuButton<void>(
                                        icon: const Icon(
                                          Icons.more_vert,
                                        ), // Vertical three dots
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry<void>>[
                                          PopupMenuItem<void>(
                                            onTap: () {
                                              // navigate to the page that
                                              // shows the exam
                                              Map<String, dynamic> examData = {
                                                AppStrings.examCourseKey:
                                                    exams[index]
                                                        .parentCourseTitle,
                                                AppStrings.examYearKey:
                                                    exams[index].examYear,
                                                AppStrings.previousScreenKey: 2,
                                                AppStrings.hasTimerOptionKey:
                                                    true,
                                                AppStrings.timerDurationKey:
                                                    exams[index].duration,
                                              };
                                              ref
                                                  .read(currentIdStubProvider
                                                      .notifier)
                                                  .changeStub({
                                                AppStrings.stubIdType:
                                                    IdType.all,
                                                AppStrings.stubId:
                                                    exams[index].examId,
                                                AppStrings.stubCourseId:
                                                    exams[index].parentCourseId,
                                              });
                                              ref
                                                  .refresh(
                                                      examQuestionsApiProvider
                                                          .notifier)
                                                  .fetchQuestions();

                                              pageNavController.navigateTo(
                                                nextScreen: AppInts
                                                    .examQuestionsPageIndex,
                                                arguments: examData,
                                              );
                                            },
                                            child: const ListTile(
                                              leading:
                                                  Icon(Icons.question_answer),
                                              title: Text('Take All'),
                                            ),
                                          ),
                                          PopupMenuItem<void>(
                                            onTap: () {
                                              // navigate to the page that
                                              // further filter the exams
                                              debugPrint(
                                                  "to page 8, exam title: examtitle");

                                              ref
                                                  .read(
                                                      currentExamYearIdProvider
                                                          .notifier)
                                                  .changeYearId(
                                                      exams[index].examId);
                                              ref
                                                  .read(
                                                      currentExamCourseIdProvider
                                                          .notifier)
                                                  .changeCourseId(exams[index]
                                                      .parentCourseId);

                                              ref
                                                  .read(
                                                      examGradeFilterApiProvider
                                                          .notifier)
                                                  .fetchExamGrades();
                                              pageNavController.navigateTo(
                                                nextScreen: AppInts
                                                    .examGradeFilterPageIndex,
                                                arguments: <String, dynamic>{
                                                  AppStrings.previousScreenKey:
                                                      2,
                                                  AppStrings.examCourseKey:
                                                      exams[index]
                                                          .parentCourseTitle,
                                                  AppStrings.examYearKey:
                                                      exams[index].examYear,
                                                  AppStrings.timerDurationKey:
                                                      exams[index].duration,
                                                  AppStrings.hasTimerOptionKey:
                                                      true,
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
                                    : CustomButton(
                                        isFilledButton: true,
                                        buttonWidth: 40,
                                        buttonHeight: 35,
                                        buttonWidget: Text(
                                          'Take',
                                          style: textTheme.labelMedium!
                                              .copyWith(
                                                  letterSpacing: 0.5,
                                                  fontFamily: "Inter",
                                                  color: Colors.white,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                        ),
                                        buttonAction: () {
                                          if (exams[index].examType ==
                                              UtilFunctions()
                                                  .getExamStringValue(
                                                      ExamType.matric)) {
                                          } else {
                                            // if null then other pages, move on to
                                            // questions page
                                            Map<String, dynamic> examData = {
                                              AppStrings.examCourseKey:
                                                  exams[index]
                                                      .parentCourseTitle,
                                              AppStrings.examYearKey:
                                                  exams[index].examYear,
                                              AppStrings.previousScreenKey: 2,
                                              AppStrings.hasTimerOptionKey:
                                                  false,
                                              AppStrings.timerDurationKey:
                                                  exams[index].duration,
                                            };
                                            ref
                                                .read(currentIdStubProvider
                                                    .notifier)
                                                .changeStub(
                                              {
                                                AppStrings.stubIdType:
                                                    IdType.all,
                                                AppStrings.stubId:
                                                    exams[index].examId,
                                                AppStrings.stubCourseId:
                                                    exams[index].parentCourseId,
                                              },
                                            );
                                            ref
                                                .refresh(
                                                    examQuestionsApiProvider
                                                        .notifier)
                                                .fetchQuestions();
                                            pageNavController.navigateTo(
                                              nextScreen: AppInts
                                                  .examQuestionsPageIndex,
                                              arguments: examData,
                                            );
                                          }
                                        },
                                      )),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
