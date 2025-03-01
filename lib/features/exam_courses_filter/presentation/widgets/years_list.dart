import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/features/exam_grade_filter/provider/exam_grade_filter_provider.dart';
import 'package:lms_system/features/exam_questions/provider/current_id_stub_provider.dart';
import 'package:lms_system/features/exam_questions/provider/exam_questions_provider.dart';
import 'package:lms_system/features/exam_courses_filter/provider/current_exam_type_provider.dart';
import 'package:lms_system/features/exam_courses_filter/provider/current_exam_year_provider.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';
import 'package:lms_system/features/exams/provider/current_exam_course_id.dart';
import 'package:lms_system/features/exams/provider/timer_provider.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';

class YearsList extends ConsumerWidget {
  final ExamCourse course;
  const YearsList({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = ref.read(pageNavigationProvider.notifier);
    final examTypeProv = ref.watch(currentExamTypeProvider);
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      itemCount: course.years.length,
      itemBuilder: (context, index) {
        final year = course.years[index];
        return Card(
          color: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Text(year.title),
            subtitle: Text('${year.questionCount} questions'),
            trailing: examTypeProv == ExamType.matric
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
                            "exam course": course.title,
                            "exam year": year.title,
                            "previousScreen": 7,
                            "hasTimerOption": true,
                          };
                          ref.read(currentIdStubProvider.notifier).changeStub({
                            "idType": IdType.all,
                            "id": year.id,
                            "courseId": course.id,
                          });
                          ref
                              .read(examQuestionsApiProvider.notifier)
                              .fetchQuestions();
                          ref.read(examTimerProvider.notifier).resetTimer();
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
                  ),
          ),
        );
      },
    );
  }
}
