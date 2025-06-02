import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/custom_gap.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/fonts.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';

class CourseRequestTile extends ConsumerWidget {
  final Course course;

  final TextTheme textTh;
  final double selectedPriceType;
  final Function onTap;
  const CourseRequestTile({
    super.key,
    required this.course,
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
          Radius.circular(4),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(6),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                height: 60,
                width: double.infinity,
                course.image,
                fit: BoxFit.fitHeight,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Image.asset(
                    fit: BoxFit.cover,
                    "assets/images/placeholder_16.png",
                    height: 60,
                    width: double.infinity,
                  );
                },
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  // Show an error widget if the image failed to load

                  return Image.asset(
                      height: 60,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      "assets/images/placeholder_16.png");
                },
              ),
            ),
          ),
          Gap(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title,
                  style: textTheme.labelLarge!.copyWith(
                      color: Colors.black, overflow: TextOverflow.ellipsis),
                ),
                Gap(
                  height: 5,
                ),
                Text(
                  "$selectedPriceType ETB",
                  style: textTheme.labelSmall!.copyWith(color: Colors.black),
                ),
              ],
            ),
          ),
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
          ),
          Gap()
        ],
      ),
    );
  }
}
