import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/features/courses/presentation/screens/course_content_page.dart';
import 'package:lms_system/features/courses/presentation/screens/courses_per_category_list.dart';
import 'package:lms_system/features/courses/presentation/screens/courses_screen.dart';
import 'package:lms_system/features/exams/presentation/screens/exam_filters_screen.dart';
import 'package:lms_system/features/exams/presentation/screens/exam_grade_filter.dart';
import 'package:lms_system/features/exams/presentation/screens/exam_questions_page.dart';
import 'package:lms_system/features/home/presentation/screens/home_screen.dart';
import 'package:lms_system/features/saved/presentation/screens/saved_screen.dart';
import 'package:lms_system/features/wrapper/provider/current_category.dart';

import '../../../exams/presentation/screens/exams_screen.dart';
import '../../provider/wrapper_provider.dart';
import '../widgets/drawer_w.dart';

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final WidgetRef ref;
  final Function onTap;
  final bool isCurr;
  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isCurr,
    required this.onTap,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    var textTh = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: SizedBox(
        height: 40,
        child: isCurr
            ? Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: isCurr ? 12 : 0),
                    decoration: BoxDecoration(
                      color: isCurr ? Colors.white : AppColors.mainBlue,
                      borderRadius: BorderRadius.circular(45),
                    ),
                    child: Icon(
                      icon,
                      color: AppColors.mainBlue,
                    ),
                  ),
                  Text(
                    label,
                    style: textTh.labelSmall!.copyWith(
                      color: Colors.white,
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
  final drKey = GlobalKey<ScaffoldState>();

  WrapperScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(pageNavigationProvider);
    final pageController = ref.read(pageNavigationProvider.notifier);
    var size = MediaQuery.of(context).size;
    final currentCategory = ref.watch(currentCategoryProvider);
    final List<Widget> pages = [
      const HomePage(), // 0
      const CoursePage(), // 1
      const SavedCoursesPage(), // 2
      const ExamsScreen(), // 3
      CoursesPerCategoryListPage(
        // 4
        category: currentCategory,
      ),
      const CourseContentPage(), // 5
      const ExamQuestionsPage(), // 6
      const ExamFiltersScreen(), // 7
      const ExamGradeFilter(), // 8
    ];
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        key: drKey,
        drawer: const Drawer(
          child: CustomDrawer(),
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
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          NavItem(
                            icon: Icons.home_outlined,
                            onTap: () => pageController.navigatePage(0),
                            label: "Home",
                            isCurr: currentPage == 0,
                            ref: ref,
                          ),
                          NavItem(
                            icon: Icons.school_outlined,
                            onTap: () => pageController.navigatePage(1),
                            label: "Courses",
                            isCurr: [1, 4, 5].contains(currentPage),
                            ref: ref,
                          ),
                          NavItem(
                            icon: Icons.bookmark_outline,
                            onTap: () => pageController.navigatePage(2),
                            label: "Saved",
                            isCurr: currentPage == 2,
                            ref: ref,
                          ),
                          NavItem(
                            icon: Icons.quiz,
                            onTap: () => pageController.navigatePage(3),
                            label: "Exams",
                            isCurr: [3, 6, 7].contains(currentPage),
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
