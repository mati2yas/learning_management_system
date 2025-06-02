import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/custom_gap.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/fonts.dart';
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
        color: mainBackgroundColor,
        elevation: 3,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      examYear.parentCourseTitle + examYear.parentCourseTitle,
                      style: textTheme.titleMedium!.copyWith(
                          color: Colors.black, overflow: TextOverflow.ellipsis),
                    ), //
                    Text(
                      examYear.title,
                      style: textTheme.labelLarge!.copyWith(
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          overflow: TextOverflow.ellipsis),
                    ),
                    Gap(
                      height: 5,
                    ),
                    Text(
                      "$selectedPriceType ETB",
                      style: textTheme.labelSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
              Gap(),
              GestureDetector(
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
              )
            ],
          ),
        ));
  }
}
