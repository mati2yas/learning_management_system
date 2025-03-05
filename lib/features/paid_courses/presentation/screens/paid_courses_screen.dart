import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/common_app_bar.dart';
import 'package:lms_system/core/common_widgets/course_card_network.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/core/utils/util_functions.dart';
import 'package:lms_system/features/courses/provider/course_content_providers.dart';
import 'package:lms_system/features/courses/provider/current_course_id.dart';
import 'package:lms_system/features/paid_courses/provider/paid_courses_provider.dart';
import 'package:lms_system/features/shared/provider/course_subbed_provider.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';

class PaidCoursesScreen extends ConsumerWidget {
  const PaidCoursesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiState = ref.watch(paidCoursesApiProvider);
    final apiController = ref.watch(paidCoursesApiProvider.notifier);

    final pageNavController = ref.read(pageNavigationProvider.notifier);
    var textTh = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CommonAppBar(titleText: "Your Courses"),
      body: apiState.when(
        loading: () => const CircularProgressIndicator(
          color: AppColors.mainBlue,
          strokeWidth: 5,
        ),
        error: (error, stack) => Center(
          child: Text(
            ApiExceptions.getExceptionMessage(error as Exception, 400),
            style: textTh.titleMedium!.copyWith(color: Colors.red),
          ),
        ),
        data: (courses) => SizedBox(
          width: double.infinity,
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: 175,
              crossAxisCount: 2,
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
                  pageNavController.navigatePage(
                    5,
                    arguments: {
                      "course": courses[index],
                      "previousScreenIndex": 2,
                    },
                  );
                },
                child: CourseCardWithImage(
                  onBookmark: () {
                    apiController.toggleSaved(courses[index]);
                  },
                  onLike: () {
                    apiController.toggleLiked(courses[index]);
                  },
                  course: courses[index],
                ),
              );
            },
            itemCount: courses.length,
          ),
        ),
      ),
    );
  }
}
