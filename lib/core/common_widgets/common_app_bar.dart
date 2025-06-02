import 'package:flutter/material.dart';
import 'package:lms_system/core/constants/app_colors.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  Widget? leading;

  PreferredSizeWidget? bottom;
  CommonAppBar({
    super.key,
    required this.titleText,
    this.leading,
    this.bottom,
  });

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // or specify your own height

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: mainBackgroundColor,
      leading: leading,
      title: Text(
        titleText,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              // fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
      ),
      centerTitle: true,
      elevation: 5,
      shadowColor: Colors.black87,
      bottom: bottom,
    );
  }
}
