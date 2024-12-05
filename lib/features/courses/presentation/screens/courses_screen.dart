import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/course_card.dart';
import 'package:lms_system/features/courses/data_source/course_detail_data_source.dart';
import 'package:lms_system/features/courses/model/categories_sub_categories.dart';
import 'package:lms_system/features/wrapper/provider/current_category.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';

import '../../../../core/app_router.dart';
import '../../provider/courses_provider.dart';
import '../widgets/category_show.dart';

class CoursePage extends ConsumerWidget {
  const CoursePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(courseProvider);
    var size = MediaQuery.of(context).size;
    var textTh = Theme.of(context).textTheme;
    final pageController = ref.read(pageNavigationProvider.notifier);
    final categoryController = ref.watch(currentCategoryProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Courses"),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size(
            MediaQuery.of(context).size.width,
            70,
          ),
          child: Container(
            color: Colors.white,
            child: SearchBar(
              backgroundColor: const WidgetStatePropertyAll(Colors.white),
              constraints: BoxConstraints.tightFor(
                width: size.width * 0.8,
                height: 40,
              ),
              leading: const Icon(Icons.search),
              hintText: "Search Course",
            ),
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
              children: categoriesData
                  .map(
                    (catData) => CategoryShow(
                      category: catData,
                      onTap: () {
                        categoryController.changeCategory(catData.categoryType);
                        pageController.navigatePage(4);
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 25),
          Text(
            "Categories",
            style: textTh.bodyLarge!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15),
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
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      Routes.courseDetails,
                      arguments: courses[index],
                    );
                  },
                  child: CourseCard(
                    course: courses[index],
                    onBookmark: () {
                      ref
                          .read(courseProvider.notifier)
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

  void handleCategorySelection(WidgetRef ref, CourseCategory category) {
    // Keep the navbar active item on 'Courses'
  }
}
