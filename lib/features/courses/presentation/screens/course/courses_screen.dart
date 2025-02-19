import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/course_card_network.dart';
import 'package:lms_system/features/courses/model/categories_sub_categories.dart';
import 'package:lms_system/features/courses/provider/course_content_providers.dart';
import 'package:lms_system/features/courses/provider/current_course_id.dart';
import 'package:lms_system/features/courses_filtered/providers/courses_filtered_provider.dart';
import 'package:lms_system/features/courses_filtered/providers/current_filter_provider.dart';
import 'package:lms_system/features/shared/presentation/widgets/custom_search_bar.dart';
import 'package:lms_system/features/wrapper/provider/current_category.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';

import '../../../provider/courses_provider.dart';
import '../../widgets/category_show.dart';

final categories = [
  "lower_grades",
  "high_school",
  "university",
  "random_courses"
];

Map<String, String> categoryFormatted = {
  "lower_grades": "Lower Grades",
  "high_school": "Highschool",
  "university": "University",
  "random_courses": "Random Courses",
};

class CoursePage extends ConsumerWidget {
  const CoursePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(coursesProvider);
    var size = MediaQuery.of(context).size;
    var textTh = Theme.of(context).textTheme;
    final pageController = ref.read(pageNavigationProvider.notifier);
    final categoryController = ref.watch(currentCategoryProvider.notifier);

    final currentCourseFilterController =
        ref.watch(currentCourseFilterProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Courses",
          style: textTh.titleLarge!.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        shadowColor: Colors.black87,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 4,
        bottom: PreferredSize(
          preferredSize: Size(
            MediaQuery.of(context).size.width,
            70,
          ),
          child: Container(
            color: Colors.white,
            child: CustomSearchBar(hintText: "Search Courses", size: size),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Text(
            "Categories",
            style: textTh.bodyLarge!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 266,
            width: double.infinity,
            child: GridView(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 125,
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 15,
              ),
              children: categories
                  .map(
                    (cat) => CategoryShow(
                      category: categoryFormatted[cat]!,
                      categoryImage: cat,
                      onTap: () {
                        currentCourseFilterController.changeFilter(cat);
                        ref
                            .read(coursesFilteredProvider.notifier)
                            .fetchCoursesFiltered(filter: cat);
                        pageController.navigatePage(4);
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 25),
          Text(
            "Courses From All Categories",
            style: textTh.bodyLarge!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: size.height * 1.35,
            width: double.infinity,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: getResponsiveChildAspectRatio(size),
                mainAxisExtent: 200,
              ),
              itemBuilder: (_, index) {
                return GestureDetector(
                  onTap: () {
                    final courseIdController =
                        ref.watch(currentCourseIdProvider.notifier);
                    courseIdController.changeCourseId(courses[index].id);

                    ref
                        .read(courseChaptersProvider.notifier)
                        .fetchCourseChapters();
                    pageController.navigatePage(
                      5,
                      arguments: {
                        "course": courses[index],
                        "previousScreenIndex": 1,
                      },
                    );
                  },
                  child: CourseCardWithImage(
                    course: courses[index],
                    onLike: () {
                      ref
                          .read(coursesProvider.notifier)
                          .toggleLiked(courses[index]);
                    },
                    onBookmark: () {
                      ref
                          .read(coursesProvider.notifier)
                          .toggleSaved(courses[index]);
                    },
                  ),
                );
              },
              itemCount: courses.length,
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

  void handleCategorySelection(WidgetRef ref, CourseCategory category) {
    // Keep the navbar active item on 'Courses'
  }
}
