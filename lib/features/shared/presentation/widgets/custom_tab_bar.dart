import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class CustomTabBar extends StatelessWidget {
  final List<Widget> tabs;
  final TabController? controller;
  final TabAlignment? alignment;
  final bool isScrollable;
  const CustomTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.alignment = TabAlignment.fill,
    required this.isScrollable,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      isScrollable: tabs.length <= 4 ? false : isScrollable,
      tabAlignment: tabs.length <= 4 ? TabAlignment.fill : alignment,
      indicatorSize: TabBarIndicatorSize.tab,
      overlayColor: WidgetStatePropertyAll<Color>(
        AppColors.mainBlue.withValues(alpha: 0.2),
      ),
      indicator: BoxDecoration(
        color: AppColors.mainBlue,
        border: Border.all(
          width: 2,
          color: AppColors.mainBlue,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      indicatorColor: Colors.white,
      labelColor: Colors.white,
      splashBorderRadius: BorderRadius.circular(8),
      tabs: tabs,
      //controller: controller,
    );
  }
}
