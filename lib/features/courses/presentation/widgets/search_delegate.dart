import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/async_error_widget.dart';
import 'package:lms_system/core/common_widgets/course_card_network.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/core/utils/util_functions.dart';
import 'package:lms_system/features/courses/provider/courses_provider.dart';
import 'package:lms_system/features/courses/provider/search_provider.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';

class CourseSearchDelegate extends SearchDelegate<Course> {
  final WidgetRef ref;

  CourseSearchDelegate(this.ref);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, Course.initial());
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ref.watch(searchResultsProvider).when(
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: AppColors.mainBlue,
              strokeWidth: 5,
            ),
          ),
          error: (error, stack) => AsyncErrorWidget(
            errorMsg: error.toString().replaceAll("Exception: ", ""),
            callback: () async {
              final allCourseController =
                  ref.read(allCoursesApiProvider.notifier);
              await allCourseController.loadCourses();
            },
          ),
          data: (courses) {
            if (courses.isEmpty) {
              return const Center(
                child: Text("No courses found for this query."),
              );
            }
            return GridView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: UtilFunctions.getResponsiveChildAspectRatio(
                    MediaQuery.of(context).size),
                mainAxisExtent: 200,
              ),
              itemBuilder: (_, index) {
                final course = courses[index];
                return GestureDetector(
                  onTap: () {
                    // Handle course selection
                  },
                  child: CourseCardWithImage(
                    course: course,
                    onLike: () async {
                      // Handle like/bookmark actions
                    },
                    onBookmark: () async {
                      // Handle like/bookmark actions
                    },
                  ),
                );
              },
              itemCount: courses.length,
            );
          },
        );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchResultsProvider).when(
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: AppColors.mainBlue,
              strokeWidth: 5,
            ),
          ),
          error: (error, stack) => AsyncErrorWidget(
            errorMsg: error.toString().replaceAll("Exception: ", ""),
            callback: () async {
              final allCourseController =
                  ref.read(allCoursesApiProvider.notifier);
              await allCourseController.loadCourses();
            },
          ),
          data: (courses) {
            final filteredCourses = courses
                .where((course) =>
                    course.title.toLowerCase().contains(query.toLowerCase()))
                .toList();
            if (filteredCourses.isEmpty) {
              return const Center(
                child: Text("No courses found"),
              );
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: UtilFunctions.getResponsiveChildAspectRatio(
                    MediaQuery.of(context).size),
                mainAxisExtent: 200,
              ),
              itemBuilder: (_, index) {
                final course = filteredCourses[index];
                return GestureDetector(
                  onTap: () {
                    // Handle course selection
                  },
                  child: CourseCardWithImage(
                    course: course,
                    onLike: () async {
                      // Handle like/bookmark actions
                    },
                    onBookmark: () async {
                      // Handle like/bookmark actions
                    },
                  ),
                );
              },
              itemCount: filteredCourses.length,
            );
          },
        );
  }
}
