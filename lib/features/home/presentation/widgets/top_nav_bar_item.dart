import 'package:flutter/material.dart';

class TopNavBarWidget extends StatelessWidget {
  const TopNavBarWidget({
    super.key,
    required this.buttonAction,
    required this.iconName,
    required this.backGroundColor,
    required this.iconColor,
    this.iconSize = 25,
  });

  final VoidCallback buttonAction;
  final IconData iconName;
  final Color backGroundColor;
  final Color iconColor;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttonAction,
      child: CircleAvatar(
        backgroundColor: backGroundColor,
        child: Center(
          child: Icon(
            iconName,
            color: iconColor,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
