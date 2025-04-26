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
    bool isWideScreen = MediaQuery.sizeOf(context).width > 600;

    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
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
              height: isWideScreen ? 125 : 100,
            ),
            Text(
              categoryName,
              style: textTh.bodyMedium!.copyWith(
                fontSize: isWideScreen
                    ? (textTh.bodyMedium!.fontSize! + 4)
                    : textTh.bodyMedium!.fontSize,
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
