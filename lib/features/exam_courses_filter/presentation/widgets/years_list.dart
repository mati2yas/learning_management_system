import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/utils/util_functions.dart';
import 'package:lms_system/features/exam_courses_filter/provider/current_exam_type_provider.dart';
import 'package:lms_system/features/exam_courses_filter/provider/current_exam_year_provider.dart';
import 'package:lms_system/features/exam_grade_filter/provider/exam_grade_filter_provider.dart';
import 'package:lms_system/features/exam_questions/provider/current_id_stub_provider.dart';
import 'package:lms_system/features/exam_questions/provider/exam_questions_provider.dart';
import 'package:lms_system/features/exams/model/exam_year.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';
import 'package:lms_system/features/exams/provider/current_exam_course_id.dart';
import 'package:lms_system/features/exams/provider/timer_provider.dart';
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
    return examTypeProv == ExamType.matric
        ? PopupMenuButton<void>(
            icon: const Icon(
              Icons.more_vert,
            ), // Vertical three dots
            itemBuilder: (BuildContext context) => <PopupMenuEntry<void>>[
              PopupMenuItem<void>(
                onTap: () {
                  // navigate to the page that
                  // shows the exam
                  Map<String, dynamic> examData = {
                    "exam course": course.title,
                    "exam year": year.title,
                    "previousScreen": 7,
                    "hasTimerOption": true,
                    "duration": year.duration,
                  };
                  ref.read(currentIdStubProvider.notifier).changeStub({
                    "idType": IdType.all,
                    "id": year.id,
                    "courseId": course.id,
                  });
                  ref
                      .refresh(examQuestionsApiProvider.notifier)
                      .fetchQuestions();
                  ref
                      .read(examTimerProvider.notifier)
                      .resetTimer(duration: year.duration);
                  pageController.navigatePage(6, arguments: examData);
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
                  pageController.navigatePage(
                    8,
                    arguments: <String, dynamic>{
                      "exam course": course.title,
                      "exam year": year,
                      "courseId": course.id,
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
              if (examTypeProv == ExamType.matric) {
              } else {
                // if null then other pages, move on to
                // questions page
                Map<String, dynamic> examData = {
                  "exam course": course.title,
                  "exam year": year.title,
                  "previousScreen": 7,
                  "hasTimerOption": false,
                };
                pageController.navigatePage(6, arguments: examData);
              }
            },
            child: const Text("Take"),
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
                    ? FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.mainBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onLongPress: () {},
                        onPressed: () {},
                        child: const Text("Pending"),
                      )
                    : FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.mainBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onLongPress: () {},
                        onPressed: () {
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
                        child: const Text("Buy"),
                      ),
          ),
        );
      },
    );
  }
}
