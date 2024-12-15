import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/courses/presentation/widgets/capter_tile.dart';

import '../../../wrapper/provider/wrapper_provider.dart';

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
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            pageController.navigatePage(1);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        surfaceTintColor: Colors.transparent,
        title: Text(
          "${course.name ?? ""} -- ${course.grades[0].name}",
          style: textTh.titleLarge!.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        shadowColor: Colors.black87,
      ),
      body: ListView.separated(
        itemCount: courseChapters.length,
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
