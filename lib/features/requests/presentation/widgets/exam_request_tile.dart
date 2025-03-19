import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/exams/model/exam_year.dart';

class ExamYearRequestTile extends ConsumerWidget {
  final ExamYear examYear;

  final TextTheme textTh;
  final double selectedPriceType;
  final Function onTap;
  const ExamYearRequestTile({
    super.key,
    required this.examYear,
    required this.textTh,
    required this.selectedPriceType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(6),
        ),
      ),
      child: ListTile(
        title: Column(
          children: [
            Text(examYear.title),
            Text(examYear.parentCourseTitle),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
              width: 220,
              child: Row(
                children: [
                  const SizedBox(width: 5),
                  Text(
                    "$selectedPriceType ETB",
                    style: textTh.labelMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
        trailing: GestureDetector(
          onTap: () {
            onTap();
          },
          child: const CircleAvatar(
            radius: 12,
            backgroundColor: Colors.red,
            child: Center(
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
