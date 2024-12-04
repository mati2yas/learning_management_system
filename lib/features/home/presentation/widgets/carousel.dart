import 'package:flutter/material.dart';
import 'package:lms_system/core/constants/colors.dart';

class CarouselPage extends StatelessWidget {
  final String tag, img;

  const CarouselPage({
    super.key,
    required this.tag,
    required this.img,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: 160,
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.mainGrey,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(flex: 7, child: Text(tag)),
          Expanded(
            flex: 5,
            child: Image.asset(
              "assets/images/$img",
            ),
          )
        ],
      ),
    );
  }
}
