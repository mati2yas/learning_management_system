import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/custom_button.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/app_ints.dart';
import 'package:lms_system/core/constants/app_strings.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/constants/fonts.dart';
import 'package:lms_system/core/utils/util_functions.dart';
import 'package:lms_system/features/exam_courses_filter/provider/current_exam_type_provider.dart';
import 'package:lms_system/features/exam_courses_filter/provider/current_exam_year_provider.dart';
import 'package:lms_system/features/exam_grade_filter/provider/exam_grade_filter_provider.dart';
import 'package:lms_system/features/exam_questions/provider/current_id_stub_provider.dart';
import 'package:lms_system/features/exam_questions/provider/exam_questions_provider.dart';
import 'package:lms_system/features/exams/model/exam_year.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';
import 'package:lms_system/features/exams/provider/current_exam_course_id.dart';
import 'package:lms_system/features/subscription/provider/requests/exam_requests_provider.dart';
import 'package:lms_system/features/subscription/provider/subscriptions/exam_subscription_provider.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';

class TakeOrFilter extends StatelessWidget {
  final WidgetRef ref;
  final ExamCourse course;
  final ExamYear year;
  const TakeOrFilter({
    super.key,
    required this.ref,
    required this.course,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    final pageController = ref.read(pageNavigationProvider.notifier);
    final examTypeProv = ref.watch(currentExamTypeProvider);
    return [ExamType.matric, ExamType.ministry8th].contains(examTypeProv)
        ? PopupMenuButton<void>(
            color: mainBackgroundColor,
            shape: Border.all(color: primaryColor, width: 0.5),
            borderRadius: BorderRadius.all(Radius.circular(5)),
            icon: const Icon(
              Icons.more_vert,
            ), // Vertical three dots
            itemBuilder: (BuildContext context) => <PopupMenuEntry<void>>[
              PopupMenuItem<void>(
                onTap: () {
                  // navigate to the page that
                  // shows the exam
                  Map<String, dynamic> examData = {
                    AppStrings.examCourseKey: course.title,
                    AppStrings.examYearKey: year.title,
                    AppStrings.previousScreenKey: 7,
                    AppStrings.hasTimerOptionKey: true,
                    AppStrings.timerDurationKey: year.duration,
                  };
                  ref.read(currentIdStubProvider.notifier).changeStub({
                    AppStrings.stubIdType: IdType.all,
                    AppStrings.stubId: year.id,
                    AppStrings.stubCourseId: course.id,
                  });
                  debugPrint(
                      "before fetching for take all: year id: ${year.id} and course id: ${course.id}");
                  ref
                      .refresh(examQuestionsApiProvider.notifier)
                      .fetchQuestions();
                  // ref
                  //     .read(examTimerProvider.notifier)
                  //     .resetTimer(duration: year.duration);
                  pageController.navigateTo(
                    //previousScreen: AppInts.examCoursesFiltersPageIndex,
                    nextScreen: AppInts.examQuestionsPageIndex,
                    arguments: examData,
                  );
                },
                child: const ListTile(
                  leading: Icon(
                    Icons.question_answer,
                    color: primaryColor,
                  ),
                  title: Text('Take all'),
                ),
              ),
              PopupMenuItem<void>(
                onTap: () {
                  // navigate to the page that
                  // further filter the exams
                  debugPrint("to page 8, exam title: examtitle");

                  ref
                      .read(currentExamYearIdProvider.notifier)
                      .changeYearId(year.id);
                  ref
                      .read(currentExamCourseIdProvider.notifier)
                      .changeCourseId(course.id);

                  ref
                      .read(examGradeFilterApiProvider.notifier)
                      .fetchExamGrades();
                  pageController.navigateTo(
                    nextScreen: AppInts.examGradeFilterPageIndex,
                    //previousScreen: AppInts.examCoursesFiltersPageIndex,
                    arguments: <String, dynamic>{
                      AppStrings.previousScreenKey: 7,
                      AppStrings.examCourseKey: course.title,
                      AppStrings.examYearKey: year,
                      AppStrings.examCourseIdKey: course.id,
                    },
                  );
                },
                child: const ListTile(
                  leading: Icon(
                    Icons.filter_alt,
                    color: primaryColor,
                  ),
                  title: Text('Take filtered'),
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
              style: textTheme.labelMedium!.copyWith(
                  letterSpacing: 0.5,
                  fontFamily: "Inter",
                  color: Colors.white,
                  overflow: TextOverflow.ellipsis),
            ),
            buttonAction: () {
              if ([ExamType.matric, ExamType.ministry8th]
                  .contains(examTypeProv)) {
                ref.read(currentIdStubProvider.notifier).changeStub({
                  AppStrings.stubIdType: IdType.filtered,
                  AppStrings.stubId: year.id,
                  AppStrings.stubCourseId: course.id,
                  //AppStrings.stubGradeId: course
                });
                ref
                    .read(currentExamYearIdProvider.notifier)
                    .changeYearId(year.id);
                ref.refresh(examQuestionsApiProvider.notifier).fetchQuestions();
                Map<String, dynamic> examData = {
                  AppStrings.examCourseKey: course.title,
                  AppStrings.examYearKey: year.title,
                  AppStrings.timerDurationKey: year.duration,
                  AppStrings.previousScreenKey: 7,
                  AppStrings.hasTimerOptionKey: false,
                };
                pageController.navigateTo(
                  nextScreen: AppInts.examQuestionsPageIndex,
                  //previousScreen: AppInts.examCoursesFiltersPageIndex,
                  arguments: examData,
                );
              } else {
                // if null then other pages, move on to
                // questions page
                ref.read(currentIdStubProvider.notifier).changeStub({
                  AppStrings.stubIdType: IdType.all,
                  AppStrings.stubId: year.id,
                  AppStrings.stubCourseId: course.id,
                });
                ref
                    .read(currentExamYearIdProvider.notifier)
                    .changeYearId(year.id);
                ref.refresh(examQuestionsApiProvider.notifier).fetchQuestions();
                Map<String, dynamic> examData = {
                  AppStrings.examCourseKey: course.title,
                  AppStrings.examYearKey: year.title,
                  AppStrings.timerDurationKey: year.duration,
                  AppStrings.previousScreenKey: 7,
                  AppStrings.hasTimerOptionKey: true,
                };
                pageController.navigateTo(
                  nextScreen: AppInts.examQuestionsPageIndex,
                  //previousScreen: AppInts.examCoursesFiltersPageIndex,
                  arguments: examData,
                );
              }
            },
          );
  }
}

class YearsList extends ConsumerWidget {
  final ExamCourse course;
  final ExamType examType;
  const YearsList({
    super.key,
    required this.course,
    required this.examType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      itemCount: course.years.length,
      itemBuilder: (context, index) {
        final year = course.years[index];
        debugPrint("year ${year.title} is subbed? ${year.subscribed}");
        return Card(
          color: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Text(year.title),
            subtitle: Text('${year.questionCount} questions'),
            trailing: year.subscribed
                ? TakeOrFilter(
                    ref: ref,
                    course: course,
                    year: year,
                  )
                : year.pending
                    ? CustomButton(
                        isFilledButton: false,
                        buttonWidth: 70,
                        buttonHeight: 35,
                        buttonWidget: Text(
                          'Pending',
                          style: textTheme.labelMedium!.copyWith(
                              letterSpacing: 0.5,
                              fontFamily: "Inter",
                              color: primaryColor,
                              overflow: TextOverflow.ellipsis),
                        ),
                        buttonAction: () {},
                      )
                    : CustomButton(
                        isFilledButton: true,
                        buttonWidth: 70,
                        buttonHeight: 35,
                        buttonWidget: Text(
                          'Add to Cart',
                          style: textTheme.labelMedium!.copyWith(
                              letterSpacing: 0.5,
                              fontFamily: "Inter",
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis),
                        ),
                        buttonAction: () {
                          debugPrint("add to requestsProv function start");
                          var requestsProv = ref.watch(examRequestsProvider);
                          debugPrint(
                              "requestsProv length: ${requestsProv.length}");

                          var subscriptionController = ref.watch(
                              examSubscriptionControllerProvider.notifier);
                          var (status, exams) = ref
                              .read(examRequestsProvider.notifier)
                              .addOrRemoveExamYear(
                                  course.years[index], examType);
                          subscriptionController.updateExams(exams);

                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            UtilFunctions.buildInfoSnackbar(
                              message: "Exam has been $status.",
                            ),
                          );
                        },
                      ),
          ),
        );
      },
    );
  }
}
