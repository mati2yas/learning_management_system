import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/features/courses/presentation/screens/courses_screen.dart';
import 'package:lms_system/features/home/presentation/screens/home_screen.dart';
import 'package:lms_system/features/profile/presentation/screens/profile_screen.dart';
import 'package:lms_system/features/saved/presentation/screens/saved_screen.dart';

import '../../provider/drawer_provider.dart';
import '../../provider/wrapper_provider.dart';
import '../widgets/drawer_w.dart';

class BottomNavigationItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const BottomNavigationItem({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index, currentIndex;
  final WidgetRef ref;
  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    bool isCurr = currentIndex == index;
    var textTh = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          ref.read(pageNavigationProvider.notifier).resetToHome();
          ref
              .read(drawerButtonProvider.notifier)
              .changeDrawerType(DrawerType.home);
        } else {
          ref.read(pageNavigationProvider.notifier).navigatePage(index);
        }
      },
      child: Container(
        width: 80,
        height: 45,
        decoration: BoxDecoration(
          color: isCurr ? Colors.white : AppColors.mainBlue,
          borderRadius: BorderRadius.circular(45),
        ),
        child: isCurr
            ? Column(
                children: [
                  Icon(
                    icon,
                    color: AppColors.mainBlue,
                  ),
                  Text(
                    label,
                    style: textTh.labelSmall!.copyWith(
                      color: AppColors.mainBlue,
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                  ),
                  Text(
                    label,
                    style: textTh.labelSmall!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class WrapperScreen extends ConsumerWidget {
  final List<Widget> pages = [
    const HomePage(),
    const CoursePage(),
    const SavedCoursesPage(),
    const ProfilePage(),
  ];
  final drKey = GlobalKey<ScaffoldState>();

  WrapperScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(pageNavigationProvider);
    final drawerType = ref.watch(drawerButtonProvider);
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        key: drKey,
        drawer: const Drawer(
          child: DrawerW(),
        ),
        body: Stack(
          children: [
            pages[currentPage],
            Positioned(
              bottom: 10,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(55),
                  ),
                  color: AppColors.mainBlue,
                  child: SizedBox(
                    width: size.width - 24,
                    height: 58,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          NavItem(
                            icon: Icons.home_outlined,
                            label: "Home",
                            index: 0,
                            currentIndex: currentPage,
                            ref: ref,
                          ),
                          NavItem(
                            icon: Icons.school_outlined,
                            label: "Courses",
                            index: 1,
                            currentIndex: currentPage,
                            ref: ref,
                          ),
                          NavItem(
                            icon: Icons.bookmark_outline,
                            label: "Saved",
                            index: 2,
                            currentIndex: currentPage,
                            ref: ref,
                          ),
                          NavItem(
                            icon: Icons.person_outline,
                            label: "Profile",
                            index: 3,
                            currentIndex: currentPage,
                            ref: ref,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
