import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/common_app_bar.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/features/courses/presentation/widgets/capter_tile.dart';
import 'package:lms_system/features/courses/provider/course_content_providers.dart';
import 'package:lms_system/features/courses/provider/current_course_id.dart';

import '../../../../wrapper/provider/wrapper_provider.dart';

class CourseChaptersScreen extends ConsumerStatefulWidget {
  const CourseChaptersScreen({super.key});

  @override
  ConsumerState<CourseChaptersScreen> createState() =>
      _CourseChaptersScreenState();
}

class _CourseChaptersScreenState extends ConsumerState<CourseChaptersScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var textTh = Theme.of(context).textTheme;
    final pageController = ref.read(pageNavigationProvider.notifier);
    final course = pageController.getArgumentsForPage(5);
    // 5 cause the 5th page in the wrapper screen pages list
    final courseIdController = ref.watch(currentCourseIdProvider.notifier);
    final courseIdcurrent = ref.watch(currentCourseIdProvider);
    final apiState = ref.watch(courseChaptersProvider);
    print(
        "course that's passed to this screen and course that's passed to the courseId, do they match ids?");
    print("course.id: ${course.id}, courseIdController: $courseIdcurrent");
    return Scaffold(
      appBar: CommonAppBar(
        leading: IconButton(
          onPressed: () {
            pageController.navigatePage(4);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        titleText: "${course.title}",
      ),
      body: apiState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: AppColors.mainBlue,
            strokeWidth: 5,
          ),
        ),
        error: (error, stack) => Center(
          child: Text(
            error.toString(),
            style: textTh.titleMedium!.copyWith(color: Colors.red),
          ),
        ),
        data: (chapters) => ListView.separated(
          itemCount: chapters.length,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          itemBuilder: (_, index) {
            return ChapterTile(chapter: chapters[index]);
          },
          separatorBuilder: (_, index) => const SizedBox(
            height: 15,
          ),
        ),
      ),
    );
  }
}
