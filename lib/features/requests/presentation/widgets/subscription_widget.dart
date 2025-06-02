import 'package:flutter/material.dart';
import 'package:lms_system/core/constants/app_colors.dart';

class SubscriptionTypeWidget extends StatelessWidget {
  final int duration;
  final Function onPress;
  final bool isActive;
  const SubscriptionTypeWidget({
    super.key,
    required this.duration,
    required this.onPress,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onPress();
        },
        child: Container(
          height: 100,
          width: 100,
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isActive ? AppColors.mainBlue : Colors.white,
            border: Border.all(
              color: AppColors.mainBlue,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                duration == 12 ? "1" : "$duration",
                style: TextStyle(
                    color: isActive ? Colors.white : Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w800),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                duration == 12
                    ? "Year"
                    : duration == 1
                        ? "Month"
                        : "Months",
                style: TextStyle(
                    color: isActive ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
