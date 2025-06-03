import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/custom_dialog.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/app_ints.dart';
import 'package:lms_system/core/constants/app_keys.dart';
import 'package:lms_system/features/courses/presentation/screens/course/course_chapters_screen.dart';
import 'package:lms_system/features/courses/presentation/screens/course/courses_screen.dart';
import 'package:lms_system/features/courses/provider/courses_provider.dart';
import 'package:lms_system/features/courses_filtered/presentation/screens/courses_filter_screen.dart';
import 'package:lms_system/features/current_user/provider/current_user_provider.dart';
import 'package:lms_system/features/exam_chapter_filter/presentation/exam_chapter_filter_screen.dart';
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
  const WrapperScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageNavData = ref.watch(pageNavigationProvider);
    final pageController = ref.read(pageNavigationProvider.notifier);
    var size = MediaQuery.of(context).size;
    final currentCategory = ref.watch(currentCategoryProvider);
    final List<Widget> pages = [
      const HomePage(), // 0
      const CoursePage(), // 1
      const ExamsScreen(), // 2
      const PaidScreen(), // 3
      const CoursesFilterScreen(), // 4
      const CourseChaptersScreen(), // 5
      const ExamQuestionsPage(), // 6
      const ExamCoursesFiltersScreen(), // 7
      const ExamGradeFilterScreen(), // 8
      const ExamChapterFilterScreen(), // 9
    ];
    if (pageNavData.currentPage == AppInts.homePageIndex) {
      ref.read(carouselApiProvider.notifier).build();
      ref.read(homeScreenApiProvider.notifier).build();
      ref.read(currentUserProvider.notifier).build();
      if (ref.read(courseRequestsProvider).isEmpty) {
        ref.read(courseRequestsProvider.notifier).loadData();
      }
      ref.read(notificationApiProvider.notifier).build();
    }
    if (pageNavData.currentPage == AppInts.coursePageIndex) {
      ref.read(allCoursesApiProvider.notifier).build();
    }
    if (pageNavData.currentPage == AppInts.paidPageIndex) {
      ref.read(bankInfoApiProvider.notifier).build();
      ref.read(paidCoursesApiProvider.notifier).build();
      ref.read(paidExamsApiProvider.notifier).build();
    }
    // if (currentPage == 3) {
    //   ref.read(examYearFilterApiProvider.notifier).build();
    // }
    int currentScreensOnStack = pageNavData.screensTrack.length;
    bool checkPopCondition =
        (currentScreensOnStack == 0 || currentScreensOnStack == 1);
    
    return PopScope(
      //canPop: checkPopCondition,
      canPop: pageNavData.screensTrack.length == 1,
      onPopInvokedWithResult: (didPop, result) {
        pageController.navigateBack();
      },

      child: Scaffold(
        backgroundColor: Colors.white,
        key: AppKeys.drawerKey,
        drawer: const CustomDrawer(),
        body: SafeArea(
          child: Stack(
            children: [
              pages[pageNavData.currentPage],
              if (pageNavData.currentPage != 6)
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
                                  pageController.navigateTo(
                                    nextScreen: AppInts.homePageIndex,
                                  );
                                },
                                label: "Home",
                                isCurr: pageNavData.currentPage ==
                                    AppInts.homePageIndex,
                                ref: ref,
                              ),
                              NavItem(
                                icon: Icons.school_outlined,
                                onTap: () {
                                  pageController.navigateTo(
                                    nextScreen: AppInts.coursePageIndex,
                                  );
                                },
                                label: "Courses",
                                isCurr: [
                                  AppInts.coursePageIndex,
                                  AppInts.coursesFilterPageIndex,
                                  AppInts.courseChaptersPageIndex,
                                ].contains(pageNavData.currentPage),
                                ref: ref,
                              ),
                              NavItem(
                                icon: Icons.quiz,
                                onTap: () {
                                  if (ref
                                          .read(pageNavigationProvider)
                                          .currentPage ==
                                      AppInts.examQuestionsPageIndex) {
                                    showCustomDialog(
                                      context: context,
                                      title: 'Confirm Leave',
                                      content: Text(
                                          "Do you really want to leave this page?",
                                          textAlign: TextAlign.center),
                                      onConfirm: () async {
                                        Navigator.of(context)
                                            .pop(); // Dismiss the dialog

                                        pageController.navigateTo(
                                          nextScreen: AppInts.examsPageIndex,
                                        );
                                      },
                                      onCancel: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icons.cancel,
                                      iconColor: Colors.red,
                                      confirmText: 'Leave Page',
                                      cancelText: 'Cancel',
                                    );

                                    // showDialog(
                                    //   context: context,
                                    //   builder: (context) {
                                    //     return AlertDialog(
                                    //       title: const Text("Confirmation"),
                                    //       content: const Text(
                                    //           "Are you sure to leave the current page?"),
                                    //       actions: [
                                    //         TextButton(
                                    //           onPressed: () {
                                    //             Navigator.of(context)
                                    //                 .pop(); // Dismiss the dialog
                                    //           },
                                    //           child: const Text("Cancel"),
                                    //         ),
                                    //         TextButton(
                                    //           onPressed: () {
                                    //             Navigator.of(context)
                                    //                 .pop(); // Dismiss the dialog

                                    //             pageController.navigateTo(
                                    //               nextScreen:
                                    //                   AppInts.examsPageIndex,
                                    //             );
                                    //           },
                                    //           child: const Text("Yes"),
                                    //         ),
                                    //       ],
                                    //     );
                                    //   },
                                    // );
                                  } else {
                                    pageController.navigateTo(
                                      nextScreen: AppInts.examsPageIndex,
                                    );
                                  }
                                },
                                label: "Exams",
                                isCurr: [
                                  AppInts.examsPageIndex,
                                  AppInts.examCoursesFiltersPageIndex,
                                ].contains(pageNavData.currentPage),
                                ref: ref,
                              ),
                              NavItem(
                                icon: Icons.workspace_premium,
                                onTap: () {
                                  pageController.navigateTo(
                                    nextScreen: AppInts.paidPageIndex,
                                  );
                                },
                                label: "Paid",
                                isCurr: pageNavData.currentPage ==
                                    AppInts.paidPageIndex,
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
      ),
    );
  }

  void showScreensSnackBar(BuildContext ctx, List<int> screensOnStack) {
    ScaffoldMessenger.of(ctx).removeCurrentSnackBar();
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text("Current screens: [ ${screensOnStack.join(", ")} ]")));
  }
}
