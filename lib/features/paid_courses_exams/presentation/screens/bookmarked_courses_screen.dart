import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/async_error_widget.dart';
import 'package:lms_system/core/common_widgets/course_card_network.dart';
import 'package:lms_system/core/common_widgets/no_data_widget.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/app_ints.dart';
import 'package:lms_system/core/utils/util_functions.dart';
import 'package:lms_system/features/courses/provider/course_content_providers.dart';
import 'package:lms_system/features/courses/provider/current_course_id.dart';
import 'package:lms_system/features/paid_courses_exams/provider/paid_courses_provider.dart';
import 'package:lms_system/features/shared/provider/course_subbed_provider.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';

class BookmarkedCoursesScreen extends ConsumerWidget {
  const BookmarkedCoursesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesApiState = ref.watch(paidCoursesApiProvider);
    var textTh = Theme.of(context).textTheme;

    final pageNavController = ref.read(pageNavigationProvider.notifier);
    var size = MediaQuery.of(context).size;

    final coursesApiController = ref.watch(paidCoursesApiProvider.notifier);
    bool isWideScreen = MediaQuery.sizeOf(context).width > 600;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Bookmarked Courses",
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
      ),
      body: coursesApiState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: AppColors.mainBlue,
            strokeWidth: 5,
          ),
        ),
        error: (error, stack) => AsyncErrorWidget(
          errorMsg: error.toString(),
          callback: () async {
            ref.refresh(paidCoursesApiProvider.notifier).fetchPaidCourses();
          },
        ),
        data: (courses) {
          courses = courses.where((course) => course.saved).toList();
          return SizedBox(
            width: double.infinity,
            child: courses.isEmpty
                ? NoDataWidget(
                    noDataMsg: "No Bookmarked Courses Yet.",
                    callback: () async {
                      await ref
                          .refresh(paidCoursesApiProvider.notifier)
                          .fetchPaidCourses();
                    },
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 210,
                      crossAxisCount: isWideScreen ? 3 : 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio:
                          UtilFunctions.getResponsiveChildAspectRatio(size),
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

                          ref
                              .read(courseSubTrackProvider.notifier)
                              .changeCurrentCourse(courses[index]);

                          debugPrint(
                              "current course: Course{ id: ${ref.read(courseSubTrackProvider).id}, title: ${ref.read(courseSubTrackProvider).title} }");
                          pageNavController.navigateTo(
                            nextScreen: AppInts.courseChaptersPageIndex,
                            arguments: {
                              "course": courses[index],
                              "previousScreenIndex": 2,
                            },
                          );
                        },
                        child: CourseCardNetworkImage(
                          mainAxisExtent: 210,
                          onBookmark: () {
                            coursesApiController.toggleSaved(courses[index]);
                          },
                          onLike: () {
                            coursesApiController.toggleLiked(courses[index]);
                          },
                          course: courses[index],
                        ),
                      );
                    },
                    itemCount: courses.length,
                  ),
          );
        },
      ),
    );
  }
}
