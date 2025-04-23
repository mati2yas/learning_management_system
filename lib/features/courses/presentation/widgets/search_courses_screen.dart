import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/async_error_widget.dart';
import 'package:lms_system/core/common_widgets/course_card_network.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/app_ints.dart';
import 'package:lms_system/features/courses/provider/course_content_providers.dart';
import 'package:lms_system/features/courses/provider/current_course_id.dart';
import 'package:lms_system/features/courses/provider/search_field_provider.dart';
import 'package:lms_system/features/courses/provider/search_prov.dart';
import 'package:lms_system/features/shared/presentation/widgets/custom_search_bar.dart';
import 'package:lms_system/features/shared/provider/course_subbed_provider.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';

class SearchCoursesScreen extends ConsumerWidget {
  const SearchCoursesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchNotifier = ref.watch(searchCoursesProvider.notifier);
    final searchedCourses = ref.watch(searchCoursesProvider);
    var size = MediaQuery.sizeOf(context);
    var textTh = Theme.of(context).textTheme;

    var searchQueryState = ref.watch(searchFieldProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            searchNotifier.clearSearch();
            ref.read(searchFieldProvider.notifier).changeFieldText("");
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        title: Text(
          "Search Courses",
          style: textTh.titleLarge!.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 5,
        shadowColor: Colors.black87,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size(size.width, 40),
          child: Container(
            width: size.width,
            color: Colors.white,
            height: 48,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
              child: CustomSearchBar(
                hintText: "Search Courses",
                size: size,
                searchCallback: () {
                  final query = ref.read(searchFieldProvider);
                  searchNotifier.searchCourses(query);
                },
                onChangedCallback: (value) {
                  ref
                      .read(searchFieldProvider.notifier)
                      .changeFieldText(value!);
                },
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        child: searchedCourses.when(
          data: (courses) {
            if (searchQueryState.isNotEmpty && courses.isEmpty) {
              return Center(
                child: Text(
                  "No courses found for this query.",
                  style: textTh.bodyLarge!.copyWith(
                    color: AppColors.mainBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                mainAxisExtent: 227,
              ),
              itemCount: courses.length,
              itemBuilder: (_, index) {
                final course = courses[index];
                return GestureDetector(
                  onTap: () {
                    final pageNavController =
                        ref.read(pageNavigationProvider.notifier);
                    final courseIdController =
                        ref.watch(currentCourseIdProvider.notifier);
                    courseIdController.changeCourseId(course.id);

                    ref
                        .read(courseChaptersProvider.notifier)
                        .fetchCourseChapters();
                    ref
                        .read(courseSubTrackProvider.notifier)
                        .changeCurrentCourse(course);

                    debugPrint(
                        "current course: Course{ id: ${ref.read(courseSubTrackProvider).id}, title: ${ref.read(courseSubTrackProvider).title} }");

                    pageNavController.navigateTo(
                      nextScreen: AppInts.courseChaptersPageIndex,
                      arguments: {"course": course},
                    );

                    Navigator.of(context).pop();
                  },
                  child: CourseCardNetworkImage(
                    mainAxisExtent: 227,
                    course: course,
                    onLike: () async {},
                    onBookmark: () async {},
                  ),
                );
              },
            );
          },
          error: (error, stack) => AsyncErrorWidget(
            errorMsg: error.toString(),
            callback: () {},
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: AppColors.mainBlue,
              strokeWidth: 5,
            ),
          ),
        ),
      ),
    );
  }
}
