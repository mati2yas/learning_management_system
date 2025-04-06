import 'package:flutter/material.dart';
import 'package:lms_system/core/constants/app_colors.dart';


class ExamCategoryShow extends StatelessWidget {
  final Function onTap;
  final String categoryImage, categoryName;

  const ExamCategoryShow({
    super.key,
    required this.onTap,
    required this.categoryImage,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    var textTh = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 2,
            color: AppColors.mainGrey,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/$categoryImage.png", // Assuming the image name matches the category ID
              height: 100,
            ),
            Text(
              categoryName,
              style: textTh.bodyMedium!.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
