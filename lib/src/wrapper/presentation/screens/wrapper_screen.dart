import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/src/courses/presentation/screens/courses_screen.dart';
import 'package:lms_system/src/home/presentation/screens/home_screen.dart';
import 'package:lms_system/src/profile/presentation/screens/profile_screen.dart';
import 'package:lms_system/src/saved/presentation/screens/saved_screen.dart';

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
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: AppColors.lighterGrey,
                  child: SizedBox(
                    width: size.width - 24,
                    height: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: BottomNavigationBar(
                        backgroundColor: AppColors.lighterGrey,
                        currentIndex: currentPage,
                        onTap: (index) {
                          if (index == 0) {
                            ref
                                .read(pageNavigationProvider.notifier)
                                .resetToHome();
                            ref
                                .read(drawerButtonProvider.notifier)
                                .changeDrawerType(DrawerType.home);
                          } else {
                            ref
                                .read(pageNavigationProvider.notifier)
                                .navigatePage(index);
                          }
                        },
                        items: const [
                          BottomNavigationBarItem(
                            icon: Icon(Icons.home_outlined),
                            label: 'Home',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.school_outlined),
                            label: 'Courses',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.bookmark_outline),
                            label: 'Saved',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.person_outline),
                            label: 'Profile',
                          ),
                        ],
                        type: BottomNavigationBarType.fixed,
                        selectedItemColor: AppColors.mainBlue,
                        unselectedItemColor: AppColors.darkerGrey,
                        showUnselectedLabels: true,
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
