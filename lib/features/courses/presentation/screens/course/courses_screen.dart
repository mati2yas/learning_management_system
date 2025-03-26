import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/async_error_widget.dart';
import 'package:lms_system/core/common_widgets/course_card_network.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/app_strings.dart';
import 'package:lms_system/core/utils/util_functions.dart';
import 'package:lms_system/features/courses/presentation/widgets/search_delegate.dart';
import 'package:lms_system/features/courses/provider/course_content_providers.dart';
import 'package:lms_system/features/courses/provider/current_course_id.dart';
import 'package:lms_system/features/courses_filtered/providers/courses_filtered_provider.dart';
import 'package:lms_system/features/courses_filtered/providers/current_filter_provider.dart';
import 'package:lms_system/features/paid_courses_exams/provider/paid_courses_provider.dart';
import 'package:lms_system/features/shared/provider/course_subbed_provider.dart';
import 'package:lms_system/features/wrapper/provider/current_category.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';

import '../../../provider/courses_provider.dart';
import '../../widgets/category_show.dart';

class CoursePage extends ConsumerWidget {
  const CoursePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(allCoursesApiProvider);
    var size = MediaQuery.of(context).size;
    var textTh = Theme.of(context).textTheme;
    final pageController = ref.read(pageNavigationProvider.notifier);
    final categoryController = ref.watch(currentCategoryProvider.notifier);

    final paidApiController = ref.watch(paidCoursesApiProvider.notifier);
    final currentCourseFilterController =
        ref.watch(currentCourseFilterProvider.notifier);
    final allCourseApiState = ref.watch(allCoursesApiProvider);
    final allCourseController = ref.watch(allCoursesApiProvider.notifier);
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
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CourseSearchDelegate(
                    widgetRef: ref, previousScreenIndex: 1),
              );
            },
          ),
        ],
        centerTitle: true,
        shadowColor: Colors.black87,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 4,
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
          const SizedBox(height: 12),
          SizedBox(
            height: 276,
            width: double.infinity,
            child: GridView(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 130,
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 15,
              ),
              children: AppStrings.courseCategories
                  .map(
                    (cat) => CategoryShow(
                      category: AppStrings.categoryFormatted(cat),
                      categoryImage: cat,
                      // onTap: () {
                      //   currentCourseFilterController.changeFilter(cat);
                      //   ref
                      //       .read(coursesFilteredProvider.notifier)
                      //       .fetchCoursesFiltered(filter: cat);
                      //   pageController.navigatePage(4);
                      // },
                      onTap: () {
                        Future.microtask(() {
                          ref
                              .read(currentCourseFilterProvider.notifier)
                              .changeFilter(cat);
                          ref
                              .read(coursesFilteredProvider.notifier)
                              .fetchCoursesFiltered(filter: cat);
                          ref
                              .read(pageNavigationProvider.notifier)
                              .navigatePage(4);
                        });
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
          allCourseApiState.when(
            loading: () => const Center(
              child: CircularProgressIndicator(
                color: AppColors.mainBlue,
                strokeWidth: 5,
              ),
            ),
            error: (error, stack) => AsyncErrorWidget(
              errorMsg: error.toString().replaceAll("Exception: ", ""),
              callback: () async {
                await ref.refresh(allCoursesApiProvider.notifier).loadCourses();
              },
            ),
            data: (courses) {
              return SizedBox(
                height: 202 * 10 + 100,
                // main-axis extent (202) multiplied by 10 per row, plus 10 times main axis spacing (10)
                width: double.infinity,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio:
                        UtilFunctions.getResponsiveChildAspectRatio(size),
                    mainAxisExtent: 202,
                  ),
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () {
                        final courseIdController =
                            ref.watch(currentCourseIdProvider.notifier);
                        courseIdController.changeCourseId(courses[index].id);

                        ref
                            .read(courseSubTrackProvider.notifier)
                            .changeCurrentCourse(courses[index]);

                        debugPrint(
                            "current course: Course{ id: ${ref.read(courseSubTrackProvider).id}, title: ${ref.read(courseSubTrackProvider).title} }");
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
                      child: CourseCardNetworkImage(
                        mainAxisExtent: 202,
                        course: courses[index],
                        onLike: () async {
                          ref
                              .read(allCoursesApiProvider.notifier)
                              .toggleLiked(courses[index]);

                          await paidApiController.toggleLiked(courses[index]);
                        },
                        onBookmark: () async {
                          ref
                              .read(allCoursesApiProvider.notifier)
                              .toggleSaved(courses[index]);

                          await paidApiController.toggleLiked(courses[index]);
                        },
                      ),
                    );
                  },
                  itemCount: courses.length,
                ),
              );
            },
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
