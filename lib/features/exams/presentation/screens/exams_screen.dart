import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/features/exam_courses_filter/provider/current_exam_type_provider.dart';
import 'package:lms_system/features/exam_courses_filter/provider/exam_courses_filter_provider.dart';
import 'package:lms_system/features/exams/presentation/widgets/exam_category.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';

class ExamsScreen extends ConsumerStatefulWidget {
  const ExamsScreen({super.key});

  @override
  ConsumerState<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends ConsumerState<ExamsScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var textTh = Theme.of(context).textTheme;
    final pageNavController = ref.read(pageNavigationProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Browse Exams"),
        centerTitle: true,
        elevation: 5,
        shadowColor: Colors.black87,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
      ),
      body: SizedBox(
        height: 600,
        width: double.infinity,
        child: GridView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: 125,
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 15,
          ),
          children: [
            ExamCategoryShow(
              onTap: () {
                ref
                    .read(currentExamTypeProvider.notifier)
                    .changeExamType(ExamType.matric);
                ref
                    .read(examCoursesFilterApiProvider.notifier)
                    .fetchExamCourses();
                pageNavController.navigatePage(7, arguments: "ESSLCE");
              },
              categoryImage: "matric",
              categoryName: "ESSLCE",
            ),
            ExamCategoryShow(
              onTap: () {
                ref
                    .read(currentExamTypeProvider.notifier)
                    .changeExamType(ExamType.exitexam);
                ref
                    .read(examCoursesFilterApiProvider.notifier)
                    .fetchExamCourses();

                pageNavController.navigatePage(7, arguments: "Exit Exam");
              },
              categoryImage: "exit_exam",
              categoryName: "Exit Exam",
            ),
            ExamCategoryShow(
              onTap: () {
                ref
                    .read(currentExamTypeProvider.notifier)
                    .changeExamType(ExamType.uat);
                ref
                    .read(examCoursesFilterApiProvider.notifier)
                    .fetchExamCourses();

                pageNavController.navigatePage(7, arguments: "UAT");
              },
              categoryImage: "uat",
              categoryName: "UAT",
            ),
            ExamCategoryShow(
              onTap: () {
                ref
                    .read(currentExamTypeProvider.notifier)
                    .changeExamType(ExamType.exitexam);
                ref
                    .read(examCoursesFilterApiProvider.notifier)
                    .fetchExamCourses();

                pageNavController.navigatePage(7, arguments: "NGAT");
              },
              categoryImage: "ngat",
              categoryName: "NGAT",
            ),
            ExamCategoryShow(
              onTap: () {
                ref
                    .read(currentExamTypeProvider.notifier)
                    .changeExamType(ExamType.ministry6th);
                ref
                    .read(examCoursesFilterApiProvider.notifier)
                    .fetchExamCourses();

                pageNavController.navigatePage(7,
                    arguments: "6th Grade Ministry");
              },
              categoryImage: "ministry_6th",
              categoryName: "6th Grade Ministry",
            ),
            ExamCategoryShow(
              onTap: () {
                ref
                    .read(currentExamTypeProvider.notifier)
                    .changeExamType(ExamType.ministry8th);
                ref
                    .read(examCoursesFilterApiProvider.notifier)
                    .fetchExamCourses();

                pageNavController.navigatePage(7,
                    arguments: "8th Grade Ministry");
              },
              categoryImage: "ministry_8th",
              categoryName: "8th Grade Ministry",
            ),
            ExamCategoryShow(
              onTap: () {
                ref
                    .read(currentExamTypeProvider.notifier)
                    .changeExamType(ExamType.sat);
                ref
                    .read(examCoursesFilterApiProvider.notifier)
                    .fetchExamCourses();

                pageNavController.navigatePage(7, arguments: "SAT");
              },
              categoryImage: "sat_exam",
              categoryName: "SAT",
            ),
            ExamCategoryShow(
              onTap: () {
                ref
                    .read(currentExamTypeProvider.notifier)
                    .changeExamType(ExamType.exam);
                ref
                    .read(examCoursesFilterApiProvider.notifier)
                    .fetchExamCourses();

                pageNavController.navigatePage(7, arguments: "Exam");
              },
              categoryImage: "other_exams",
              categoryName: "Exam",
            ),
          ],
        ),
      ),
    );
  }
}
