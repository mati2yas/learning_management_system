import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/async_error_widget.dart';
import 'package:lms_system/core/common_widgets/common_app_bar.dart';
import 'package:lms_system/core/common_widgets/no_data_widget.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/status_bar_styles.dart';
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

    SystemChrome.setSystemUIOverlayStyle(darkAppBarSystemOverlayStyle);
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: CommonAppBar(
        leading: IconButton(
          onPressed: () {
            //pageController.navigatePage(previousScreen);
            pageController.navigateBack();
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
        error: (error, stack) {
          return AsyncErrorWidget(
            errorMsg: error.toString(),
            callback: () async {
              await ref
                  .refresh(courseChaptersProvider.notifier)
                  .fetchCourseChapters();
            },
          );
        },
        data: (chapters) => chapters.isEmpty
            ? NoDataWidget(
                noDataMsg: "No Chapters for this course yet.",
                callback: () async {
                  await ref
                      .refresh(courseChaptersProvider.notifier)
                      .fetchCourseChapters();
                },
              )
            : Padding(
                padding: const EdgeInsets.only(bottom: 70),
                child: ListView.separated(
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
      ),
    );
  }
}
