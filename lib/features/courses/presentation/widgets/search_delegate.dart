import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/async_error_widget.dart';
import 'package:lms_system/core/common_widgets/course_card_network.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/utils/util_functions.dart';
import 'package:lms_system/features/courses/provider/course_content_providers.dart';
import 'package:lms_system/features/courses/provider/courses_provider.dart';
import 'package:lms_system/features/courses/provider/current_course_id.dart';
import 'package:lms_system/features/courses/provider/search_provider.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';
import 'package:lms_system/features/shared/provider/course_subbed_provider.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';

class CourseSearchDelegate extends SearchDelegate<Course> {
  final WidgetRef widgetRef;
  final int previousScreenIndex;

  CourseSearchDelegate({
    required this.widgetRef,
    required this.previousScreenIndex,
  });

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
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(12),
        child: widgetRef.watch(searchResultsProvider).when(
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: AppColors.mainBlue,
                  strokeWidth: 5,
                ),
              ),
              error: (error, stack) => AsyncErrorWidget(
                errorMsg: error.toString(),
                callback: () async {
                  final allCourseController =
                      widgetRef.read(allCoursesApiProvider.notifier);
                  await allCourseController.loadCourses();
                },
              ),
              data: (courses) {
                if (courses.isEmpty) {
                  return const Center(
                    child: Text("No courses found for this query."),
                  );
                }
                return Scaffold(
                  body: Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(12),
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio:
                            UtilFunctions.getResponsiveChildAspectRatio(
                                MediaQuery.of(context).size),
                        mainAxisExtent: 227,
                      ),
                      itemBuilder: (_, index) {
                        final course = courses[index];
                        return GestureDetector(
                          onTap: () {
                            // Handle course selection

                            final pageNavController =
                                widgetRef.read(pageNavigationProvider.notifier);
                            final courseIdController = widgetRef
                                .watch(currentCourseIdProvider.notifier);
                            courseIdController
                                .changeCourseId(courses[index].id);

                            widgetRef
                                .read(courseChaptersProvider.notifier)
                                .fetchCourseChapters();

                            widgetRef
                                .read(courseSubTrackProvider.notifier)
                                .changeCurrentCourse(courses[index]);

                            debugPrint(
                                "current course: Course{ id: ${widgetRef.read(courseSubTrackProvider).id}, title: ${widgetRef.read(courseSubTrackProvider).title} }");
                            pageNavController.navigatePage(
                              5,
                              arguments: {
                                "course": courses[index],
                                "previousScreenIndex": previousScreenIndex,
                              },
                            );
                            close(context, courses[index]);
                            Navigator.of(context).pop();
                          },
                          child: CourseCardNetworkImage(
                            mainAxisExtent: 227,
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
                    ),
                  ),
                );
              },
            ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return widgetRef.watch(searchResultsProvider).when(
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: AppColors.mainBlue,
              strokeWidth: 5,
            ),
          ),
          error: (error, stack) => AsyncErrorWidget(
            errorMsg: error.toString(),
            callback: () async {
              final allCourseController =
                  widgetRef.read(allCoursesApiProvider.notifier);
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
                mainAxisSpacing: 2,
                crossAxisSpacing: 0,
                childAspectRatio: UtilFunctions.getResponsiveChildAspectRatio(
                    MediaQuery.of(context).size),
                mainAxisExtent: 235,
              ),
              itemBuilder: (_, index) {
                final course = filteredCourses[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      // Handle course selection
                      final pageNavController =
                          widgetRef.read(pageNavigationProvider.notifier);
                      final courseIdController =
                          widgetRef.watch(currentCourseIdProvider.notifier);

                      courseIdController
                          .changeCourseId(filteredCourses[index].id);

                      widgetRef
                          .read(courseChaptersProvider.notifier)
                          .fetchCourseChapters();

                      widgetRef
                          .read(courseSubTrackProvider.notifier)
                          .changeCurrentCourse(filteredCourses[index]);

                      debugPrint(
                          "Current course ID: ${widgetRef.read(currentCourseIdProvider)}");
                      debugPrint(
                          "Current course: ${widgetRef.read(courseSubTrackProvider)}");

                      pageNavController.navigatePage(
                        5,
                        arguments: {
                          "course": filteredCourses[index],
                          "previousScreenIndex": previousScreenIndex,
                        },
                      );
                      close(context, filteredCourses[index]);
                    },
                    child: CourseCardNetworkImage(
                      mainAxisExtent: 235,
                      course: course,
                      onLike: () async {
                        // Handle like/bookmark actions
                      },
                      onBookmark: () async {
                        // Handle like/bookmark actions
                      },
                    ),
                  ),
                );
              },
              itemCount: filteredCourses.length,
            );
          },
        );
  }
}
