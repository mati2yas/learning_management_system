import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class CategoryShow extends StatelessWidget {
  final String category; // Accept the Category model
  final String categoryImage;
  final Function onTap;
  final bool isWideScreen;

  const CategoryShow({
    super.key,
    required this.category,
    required this.isWideScreen,
    required this.categoryImage,
    required this.onTap,
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
        height: isWideScreen ? 140 : 100,
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
              height: isWideScreen ? 140 : 100,
            ),
            Text(
              category == "Lower Grades" ? "Elementary" : category,
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
