import 'package:flutter/material.dart';
import 'package:lms_system/core/constants/app_colors.dart';

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
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: MediaQuery.sizeOf(context).width * 0.85,
      height: 130,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.mainBlue,
          width: 1,
        ),
        boxShadow: const [BoxShadow()],
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.3, 0.6],
          colors: [
            AppColors.mainBlue,
            // AppColors.mainBlue.withValues(alpha: 0.3),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
              flex: 7,
              child: Text(
                tag,
                style: const TextStyle(
                  color: Colors.white,
                ),
              )),
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
