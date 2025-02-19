import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/exam_year_filter/provider/current_exam_type_provider.dart';
import 'package:lms_system/features/exam_year_filter/provider/exam_year_filter_provider.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';
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
        title: const Text("Exam Simulator"),
        centerTitle: true,
        elevation: 5,
        shadowColor: Colors.black87,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
      ),
      body: SizedBox(
        height: 400,
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
                ref.read(examYearFilterApiProvider.notifier).fetchExamYears();
                pageNavController.navigatePage(7);
              },
              categoryImage: "high_school",
              categoryName: "ESSLCE",
            ),
            ExamCategoryShow(
              onTap: () {
                ref
                    .read(currentExamTypeProvider.notifier)
                    .changeExamType(ExamType.ministry);
                ref.read(examYearFilterApiProvider.notifier).fetchExamYears();

                pageNavController.navigatePage(7);
              },
              categoryImage: "high_school",
              categoryName: "8th Grade Ministry",
            ),
            ExamCategoryShow(
              onTap: () {
                ref
                    .read(currentExamTypeProvider.notifier)
                    .changeExamType(ExamType.coc);
                ref.read(examYearFilterApiProvider.notifier).fetchExamYears();

                pageNavController.navigatePage(7);
              },
              categoryImage: "university",
              categoryName: "Exit Exam",
            ),
            ExamCategoryShow(
              onTap: () {
                ref
                    .read(currentExamTypeProvider.notifier)
                    .changeExamType(ExamType.exitexam);
                ref.read(examYearFilterApiProvider.notifier).fetchExamYears();

                pageNavController.navigatePage(7);
              },
              categoryImage: "university",
              categoryName: "NGAT",
            ),
          ],
        ),
      ),
    );
  }
}
