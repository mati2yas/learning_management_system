import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/common_app_bar.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/features/chapter_content/provider/current_chapter_id_provider.dart';
import 'package:lms_system/features/courses/presentation/widgets/capter_tile.dart';
import 'package:lms_system/features/courses/provider/course_content_providers.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';

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
    final Map<String, dynamic> args = pageController.getArgumentsForPage(5);
    final course = args["course"] as Course;
    final previousScreen = args["previousScreenIndex"];
    // 5 cause the 5th page in the wrapper screen pages list
    //final courseIdcurrent = ref.watch(currentCourseIdProvider);
    final apiState = ref.watch(courseChaptersProvider);

    final currentChapterId = ref.watch(currentChapterIdProvider);
    return Scaffold(
      appBar: CommonAppBar(
        leading: IconButton(
          onPressed: () {
            pageController.navigatePage(previousScreen);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        titleText: "${course.title} Chapters",
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
        data: (chapters) => chapters.isEmpty
            ? Center(
                child: Text(
                  "No Chapters for this course yet.",
                  style:
                      textTh.bodyLarge!.copyWith(fontWeight: FontWeight.w700),
                ),
              )
            : ListView.separated(
                itemCount: chapters.length,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
