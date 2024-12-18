import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/exams/presentation/widgets/exam_category.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';

import '../../provider/exams_provider.dart';

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
    final examsController = ref.watch(examsProvider.notifier);
    final exams = ref.read(examsProvider);
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
              exam: exams[0],
              onTap: () {
                pageNavController.navigatePage(7, arguments: exams[0]);
              },
              categoryImage: "high_school",
              categoryName: "Matric",
            ),
            ExamCategoryShow(
              exam: exams[0],
              onTap: () {
                pageNavController.navigatePage(7, arguments: exams[1]);
              },
              categoryImage: "high_school",
              categoryName: "COC",
            ),
            ExamCategoryShow(
              exam: exams[2],
              onTap: () {
                pageNavController.navigatePage(7, arguments: exams[2]);
              },
              categoryImage: "university",
              categoryName: "COC",
            ),
            ExamCategoryShow(
              exam: exams[2],
              onTap: () {
                pageNavController.navigatePage(7, arguments: exams[2]);
              },
              categoryImage: "university",
              categoryName: "COC",
            ),
          ],
        ),
      ),
    );
  }
}
