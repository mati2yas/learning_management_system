import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lms_system/core/common_widgets/course_card.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/features/home/presentation/widgets/carousel.dart';
import 'package:lms_system/features/home/presentation/widgets/category_indicator.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: SvgPicture.asset(
                "assets/svgs/hamburger_menu.svg",
                width: 30,
                height: 30,
              ),
            ),
          );
        }),
        backgroundColor: AppColors.mainBlue,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text(
              "Hello",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "${user.name} ${user.lastName}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                color: Colors.white,
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                color: Colors.white,
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          16, // left
          10, // top
          16, // right
          0, // bottom
        ),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            SizedBox(
              width: size.width * 0.8,
              height: 140,
              child: PageView.builder(
                itemBuilder: (_, index) {
                  return CarouselPage(
                    tag: pageviewParts["tag"]!,
                    img: pageviewParts["img"]!,
                  );
                },
                itemCount: 2,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Top Category",
                  style: textTh.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "See All",
                  style: textTh.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.mainGrey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 120,
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
            const SizedBox(height: 20),
            SizedBox(
              height: size.height * 0.5,
              width: double.infinity,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
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
