import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lms_system/core/common_widgets/course_card.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/features/home/presentation/widgets/carousel.dart';
import 'package:lms_system/features/home/presentation/widgets/category_indicator.dart';
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
    print("ktoolbarheight: $kToolbarHeight");
    final PageController pageController = PageController();
    return Scaffold(
      backgroundColor: AppColors.mainBlue,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
            kToolbarHeight + 76), // Adjust for AppBar height + bottom
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 12.0, vertical: 8.0), // Adjust the margins
          child: AppBar(
            leading: Builder(builder: (context) {
              return SizedBox(
                width: 47,
                child: GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: SvgPicture.asset(
                    "assets/svgs/hamburger_menu.svg",
                  ),
                ),
              );
            }),
            backgroundColor: AppColors.mainBlue,
            actions: const [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Center(
                  child: Icon(
                    Icons.search,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(width: 10),
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Center(
                  child: Icon(
                    Icons.notifications,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(75),
              child: SizedBox(
                width: double.infinity,
                height: 75,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    right: 16.0,
                    top: 20,
                  ), // Add horizontal padding to the bottom section
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "👋 Hello",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${user.name} ${user.lastName}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(
          12, // left
          14, // top
          12, // right
          0, // bottom
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              height: 115,
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
                    height: 75,
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
                  const SizedBox(height: 5),
                  SmoothPageIndicator(
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
                  style: textTh.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "See All",
                  style: textTh.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.mainGrey,
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
            SizedBox(
              height: size.height * 0.43,
              width: double.infinity,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (_, index) {
                  return CourseCard(
                      onBookmark: () {
                        ref
                            .read(courseProvider.notifier)
                            .toggleSaved(courses[index]);
                      },
                      course: courses[index]);
                },
                itemCount: courses.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
