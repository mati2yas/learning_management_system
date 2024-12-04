import 'package:flutter/material.dart';
import 'package:lms_system/core/app_router.dart';

import '../../../../core/constants/colors.dart';
import '../../model/categories_sub_categories.dart';

class CategoryShow extends StatelessWidget {
  final CourseCategory category; // Accept the Category model

  const CategoryShow({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    var textTh = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          Routes.courseDetails,
          arguments: category,
        );
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
              "assets/images/${category.id}.png", // Assuming the image name matches the category ID
              height: 100,
            ),
            Text(
              category.name,
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
