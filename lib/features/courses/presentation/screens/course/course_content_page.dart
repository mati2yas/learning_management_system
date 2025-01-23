import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/common_app_bar.dart';
import 'package:lms_system/features/courses/presentation/widgets/capter_tile.dart';

import '../../../../wrapper/provider/wrapper_provider.dart';

class CourseContentPage extends ConsumerStatefulWidget {
  const CourseContentPage({super.key});

  @override
  ConsumerState<CourseContentPage> createState() => _CourseContentPageState();
}

class _CourseContentPageState extends ConsumerState<CourseContentPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var textTh = Theme.of(context).textTheme;
    final pageController = ref.read(pageNavigationProvider.notifier);
    final course = pageController.getArgumentsForPage(5);
    final courseChapters = course!.grades[0].courses[0].chapters;
    // 5 cause the 5th page in the wrapper screen pages list
    return Scaffold(
      appBar: CommonAppBar(
        leading: IconButton(
          onPressed: () {
            pageController.navigatePage(4);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        titleText: " ${course.name ?? ""} -- ${course.grades[0].name}",
      ),
      body: ListView.separated(
        itemCount: courseChapters.length,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        itemBuilder: (_, index) {
          return ChapterTile(chapter: courseChapters[index]);
        },
        separatorBuilder: (_, index) => const SizedBox(
          height: 15,
        ),
      ),
    );
  }
}
