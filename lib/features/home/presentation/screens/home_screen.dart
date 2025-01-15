import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/course_card_network.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/features/home/presentation/widgets/carousel.dart';
import 'package:lms_system/features/home/presentation/widgets/category_indicator.dart';
import 'package:lms_system/features/home/presentation/widgets/custom_home_app_bar_widget.dart';
import 'package:lms_system/features/home/provider/home_api_provider.dart';
import 'package:lms_system/features/wrapper/presentation/widgets/drawer_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../courses/provider/courses_provider.dart';
import '../../provider/home_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final courses = ref.watch(courseProvider);
    final pageviewParts = ref.watch(pageviewPartsProvider);
    var textTh = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;

    final homeApiState = ref.watch(homeScreenApiProvider);
    print("ktoolbarheight: $kToolbarHeight");
    final PageController pageController = PageController();
    return Scaffold(
      backgroundColor: AppColors.mainBlue,
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          CustomHomeAppBar(user: user),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: Container(
              // height: double.infinity,
              height: size.height - 160,
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 150,
                      margin: const EdgeInsets.only(top: 8),
                      width: size.width * 0.8,
                      decoration: const BoxDecoration(
                        color: AppColors.mainBlue,
                        borderRadius: BorderRadius.all(
                          Radius.circular(18),
                        ),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 105,
                            width: size.width * 0.7,
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
                          const SizedBox(height: 10),
                          SmoothPageIndicator(
                            effect: const WormEffect(
                                dotHeight: 8,
                                dotWidth: 8,
                                dotColor: AppColors.darkerGrey,
                                activeDotColor: Colors.white),
                            controller: pageController,
                            count: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Top Category",
                          style: textTh.titleMedium!.copyWith(
                              fontWeight: FontWeight.w600, letterSpacing: 0.7),
                        ),
                        Text(
                          "See All",
                          style: textTh.titleMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.mainBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 90,
                      width: double.infinity,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          CategoryIndicator(
                            title: "Marketing",
                            color: AppColors.courseCategoryColors[0],
                            image: "marketing_course.png",
                          ),
                          const SizedBox(width: 5),
                          CategoryIndicator(
                            title: "Web Design",
                            color: AppColors.courseCategoryColors[1],
                            image: "web_design.png",
                          ),
                          const SizedBox(width: 5),
                          CategoryIndicator(
                            title: "Freshman Courses",
                            color: AppColors.courseCategoryColors[2],
                            image: "marketing_course.png",
                          ),
                          const SizedBox(width: 5),
                          CategoryIndicator(
                            title: "Lower Grades",
                            color: AppColors.courseCategoryColors[3],
                            image: "marketing_course.png",
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
                      loading: () => const CircularProgressIndicator(
                        color: AppColors.mainBlue,
                        strokeWidth: 5,
                      ),
                      error: (error, stack) => Center(
                        child: Text(error.toString()),
                      ),
                      data: (courses) => SizedBox(
                        width: double.infinity,
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 30),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio:
                                getResponsiveChildAspectRatio(size),
                          ),
                          itemBuilder: (_, index) {
                            return CourseCardWithImage(
                              onBookmark: () {
                                ref
                                    .read(courseProvider.notifier)
                                    .toggleSaved(courses[index]);
                              },
                              onLike: () {
                                ref
                                    .read(courseProvider.notifier)
                                    .toggleLiked(courses[index]);
                              },
                              course: courses[index],
                            );
                          },
                          itemCount: courses.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  getResponsiveChildAspectRatio(Size size) {
    print("width: ${size.width}");
    if (size.width <= 200) return 0.65;
    if (size.width <= 400) return 0.85;

    if (size.width < 500) return 1.0;
    if (size.width < 600) return 1.3;
    if (size.width < 700) return 1.4;
    return 1.7;
  }
}
