import 'package:flutter/material.dart';

import '../app_router.dart';
import '../constants/colors.dart';

const List<BottomNavigationBarItem> _navItems = [
  BottomNavigationBarItem(
    icon: Icon(Icons.home_outlined),
    label: 'Home',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.school),
    label: 'Courses',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.bookmark),
    label: 'Saved',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.person),
    label: 'Profile',
  ),
];

class Navbar extends StatelessWidget {
  final int currentIdx;
  const Navbar({
    super.key,
    required this.currentIdx,
  });

  @override
  Widget build(BuildContext context) {
    List<String> routes = [
      Routes.home,
      Routes.courses,
      Routes.savedCourses,
      Routes.profile,
    ];
    return BottomNavigationBar(
      backgroundColor: AppColors.lighterGrey,
      currentIndex: currentIdx,
      onTap: (current) {
        Navigator.of(context).pushReplacementNamed(routes[current]);
      },
      items: _navItems,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.mainBlue,
      unselectedItemColor: AppColors.darkerGrey,
      showUnselectedLabels: true,
    );
  }
}
