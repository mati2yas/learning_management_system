import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/async_error_widget.dart';
import 'package:lms_system/core/common_widgets/course_card_network.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/utils/util_functions.dart';
import 'package:lms_system/features/courses/provider/course_content_providers.dart';
import 'package:lms_system/features/courses/provider/current_course_id.dart';
import 'package:lms_system/features/courses_filtered/providers/courses_filtered_provider.dart';
import 'package:lms_system/features/courses_filtered/providers/current_filter_provider.dart';
import 'package:lms_system/features/current_user/provider/current_user_provider.dart';
import 'package:lms_system/features/home/presentation/widgets/carousel.dart';
import 'package:lms_system/features/home/presentation/widgets/category_indicator.dart';
import 'package:lms_system/features/home/presentation/widgets/custom_home_app_bar_widget.dart';
import 'package:lms_system/features/home/provider/home_api_provider.dart';
import 'package:lms_system/features/shared/provider/course_subbed_provider.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../provider/home_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageviewParts = ref.watch(pageviewPartsProvider);
    var textTh = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;

    final pageNavController = ref.read(pageNavigationProvider.notifier);

    final currentCourseFilterController =
        ref.watch(currentCourseFilterProvider.notifier);

    final homeApiState = ref.watch(homeScreenApiProvider);
    final homeApiController = ref.watch(homeScreenApiProvider.notifier);
    final currentUserState = ref.watch(currentUserProvider);

    print("ktoolbarheight: $kToolbarHeight");
    final PageController pageController = PageController();
    return Scaffold(
      backgroundColor: AppColors.mainBlue,
      body: SizedBox(
        height: size.height,
        child: Column(
          children: [
            CustomHomeAppBar(userState: currentUserState),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Container(
                height: size.height - 164,
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        height: 160,
                        width: size.width * 0.85,
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 130,
                              width: size.width * 0.85,
                              child: PageView.builder(
                                controller: pageController,
                                itemBuilder: (_, index) {
                                  return CarouselPage(
                                    tag: pageviewParts["tag"]!,
                                    img: pageviewParts["img"]!,
                                  );
                                },
                                itemCount: 2,
                              ),
                            ),
                            const SizedBox(height: 6),
                            SmoothPageIndicator(
                              effect: const WormEffect(
                                dotHeight: 8,
                                dotWidth: 8,
                                strokeWidth: 2,
                                dotColor: AppColors.darkerGrey,
                                activeDotColor: AppColors.mainBlue,
                              ),
                              controller: pageController,
                              count: 2,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Top Category",
                          style: textTh.titleMedium!.copyWith(
                              fontWeight: FontWeight.w600, letterSpacing: 0.7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 90,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                currentCourseFilterController
                                    .changeFilter("lower_grades");
                                ref
                                    .read(coursesFilteredProvider.notifier)
                                    .fetchCoursesFiltered(
                                        filter: "lower_grades");
                                pageNavController.navigatePage(4);
                              },
                              child: CategoryIndicator(
                                title: "Lower Grades",
                                color: AppColors.courseCategoryColors[0],
                                image: "marketing_course.png",
                              ),
                            ),
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTap: () {
                                currentCourseFilterController
                                    .changeFilter("high_school");
                                ref
                                    .read(coursesFilteredProvider.notifier)
                                    .fetchCoursesFiltered(
                                        filter: "high_school");
                                pageNavController.navigatePage(4);
                              },
                              child: CategoryIndicator(
                                title: "High School",
                                color: AppColors.courseCategoryColors[1],
                                image: "web_design.png",
                              ),
                            ),
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTap: () {
                                currentCourseFilterController
                                    .changeFilter("university");
                                ref
                                    .read(coursesFilteredProvider.notifier)
                                    .fetchCoursesFiltered(filter: "university");
                                pageNavController.navigatePage(4);
                              },
                              child: CategoryIndicator(
                                title: "University",
                                color: AppColors.courseCategoryColors[2],
                                image: "marketing_course.png",
                              ),
                            ),
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTap: () {
                                currentCourseFilterController
                                    .changeFilter("random_courses");
                                ref
                                    .read(coursesFilteredProvider.notifier)
                                    .fetchCoursesFiltered(
                                        filter: "random_courses");
                                pageNavController.navigatePage(4);
                              },
                              child: CategoryIndicator(
                                title: "Other Courses",
                                color: AppColors.courseCategoryColors[3],
                                image: "marketing_course.png",
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 9),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Popular courses for you",
                          style: textTh.titleMedium!.copyWith(
                              fontWeight: FontWeight.w600, letterSpacing: 0.7),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      homeApiState.when(
                        loading: () => const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.mainBlue,
                            strokeWidth: 5,
                          ),
                        ),
                        error: (error, stack) => AsyncErrorWidget(
                          errorMsg:
                              error.toString().replaceAll("Exception: ", ""),
                          callback: () async {
                            await ref
                                .refresh(homeScreenApiProvider.notifier)
                                .build();
                          },
                        ),
                        data: (courses) => SizedBox(
                          width: double.infinity,
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 30),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisExtent: 194,
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio:
                                  UtilFunctions.getResponsiveChildAspectRatio(
                                      size),
                            ),
                            itemBuilder: (_, index) {
                              return GestureDetector(
                                onTap: () {
                                  final courseIdController = ref
                                      .watch(currentCourseIdProvider.notifier);
                                  courseIdController
                                      .changeCourseId(courses[index].id);

                                  ref
                                      .read(courseChaptersProvider.notifier)
                                      .fetchCourseChapters();

                                  ref
                                      .read(courseSubTrackProvider.notifier)
                                      .changeCurrentCourse(courses[index]);

                                  debugPrint(
                                      "current course: Course{ id: ${ref.read(courseSubTrackProvider).id}, title: ${ref.read(courseSubTrackProvider).title} }");
                                  pageNavController.navigatePage(
                                    5,
                                    arguments: {
                                      "course": courses[index],
                                      "previousScreenIndex": 0,
                                    },
                                  );
                                },
                                child: CourseCardWithImage(
                                  onBookmark: () {
                                    homeApiController
                                        .toggleSaved(courses[index]);
                                  },
                                  onLike: () {
                                    homeApiController
                                        .toggleLiked(courses[index]);
                                  },
                                  course: courses[index],
                                ),
                              );
                            },
                            itemCount: courses.length,
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
