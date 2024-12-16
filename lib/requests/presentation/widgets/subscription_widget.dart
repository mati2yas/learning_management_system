import 'package:flutter/material.dart';
import 'package:lms_system/core/constants/colors.dart';

class SubscriptionWidget extends StatelessWidget {
  final int duration;
  final Function onPress;
  final bool isActive;
  const SubscriptionWidget({
    super.key,
    required this.duration,
    required this.onPress,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPress();
      },
      child: Container(
        height: 60,
        width: 65,
        decoration: BoxDecoration(
          color: isActive ? AppColors.mainBlue : Colors.white,
          border: Border.all(
            color: AppColors.mainBlue,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              "$duration",
              style: TextStyle(
                color: isActive ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Months",
              style: TextStyle(
                color: isActive ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
