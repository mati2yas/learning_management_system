import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/app_keys.dart';
import 'package:lms_system/features/courses/presentation/screens/course/course_chapters_screen.dart';
import 'package:lms_system/features/courses/presentation/screens/course/courses_screen.dart';
import 'package:lms_system/features/courses/provider/courses_provider.dart';
import 'package:lms_system/features/courses_filtered/presentation/screens/courses_filter_screen.dart';
import 'package:lms_system/features/current_user/provider/current_user_provider.dart';
import 'package:lms_system/features/exam_courses_filter/presentation/screens/exam_courses_filter_screen.dart';
import 'package:lms_system/features/exam_grade_filter/presentation/screens/exam_grade_filter_screen.dart';
import 'package:lms_system/features/exam_questions/presentation/exam_questions_page.dart';
import 'package:lms_system/features/home/presentation/screens/home_screen.dart';
import 'package:lms_system/features/home/provider/carousel_provider.dart';
import 'package:lms_system/features/home/provider/home_api_provider.dart';
import 'package:lms_system/features/notification/provider/notification_provider.dart';
import 'package:lms_system/features/paid_courses_exams/presentation/screens/paid_screen.dart';
import 'package:lms_system/features/paid_courses_exams/provider/paid_courses_provider.dart';
import 'package:lms_system/features/paid_courses_exams/provider/paid_exam_provider.dart';
import 'package:lms_system/features/subscription/provider/bank_info_provider.dart';
import 'package:lms_system/features/subscription/provider/requests/course_requests_provider.dart';
import 'package:lms_system/features/wrapper/presentation/widgets/nav_item.dart';
import 'package:lms_system/features/wrapper/provider/current_category.dart';

import '../../../exams/presentation/screens/exams_screen.dart';
import '../../provider/wrapper_provider.dart';
import '../widgets/drawer_widget.dart';

class WrapperScreen extends ConsumerWidget {
  const WrapperScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(pageNavigationProvider);
    final pageController = ref.read(pageNavigationProvider.notifier);
    var size = MediaQuery.of(context).size;
    final currentCategory = ref.watch(currentCategoryProvider);
    final List<Widget> pages = [
      const HomePage(), // 0
      const CoursePage(), // 1
      const PaidScreen(), // 2
      const ExamsScreen(), // 3
      const CoursesFilterScreen(), // 4
      const CourseChaptersScreen(), // 5
      const ExamQuestionsPage(), // 6
      const ExamCoursesFiltersScreen(), // 7
      const ExamGradeFilterScreen(), // 8
    ];
    if (currentPage == 0) {
      ref.read(carouselApiProvider.notifier).build();
      ref.read(homeScreenApiProvider.notifier).build();
      ref.read(currentUserProvider.notifier).build();
      if (ref.read(courseRequestsProvider).isEmpty) {
        ref.read(courseRequestsProvider.notifier).loadData();
      }
      ref.read(notificationApiProvider.notifier).build();
    }
    if (currentPage == 1) {
      ref.read(allCoursesApiProvider.notifier).build();
    }
    if (currentPage == 2) {
      ref.read(bankInfoApiProvider.notifier).build();
      ref.read(paidCoursesApiProvider.notifier).build();
      ref.read(paidExamsApiProvider.notifier).build();
    }
    // if (currentPage == 3) {
    //   ref.read(examYearFilterApiProvider.notifier).build();
    // }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        key: AppKeys.drawerKey,
        drawer: const CustomDrawer(),
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
                            onTap: () {
                              pageController.navigatePage(0);
                            },
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
                            icon: Icons.workspace_premium,
                            onTap: () => pageController.navigatePage(2),
                            label: "Paid",
                            isCurr: currentPage == 2,
                            ref: ref,
                          ),
                          NavItem(
                            icon: Icons.quiz,
                            onTap: () {
                              if (ref.read(pageNavigationProvider) == 6) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Confirmation"),
                                      content: const Text(
                                          "Are you sure to leave the current page?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Dismiss the dialog
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Dismiss the dialog

                                            pageController.navigatePage(3);
                                          },
                                          child: const Text("Yes"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                pageController.navigatePage(3);
                              }
                            },
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
