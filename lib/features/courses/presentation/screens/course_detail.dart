import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/courses/presentation/widgets/capter_tile.dart';

import '../../../shared_course/model/shared_course_model.dart';
import '../../provider/courses_provider.dart';

class CourseDetailPage extends ConsumerWidget {
  final Course course;

  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseNotifier = ref.read(courseProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        itemCount: course.chapters.length,
        itemBuilder: (BuildContext context, int index) {
          var chapter = course.chapters[index];
          return ChapterTile(chapter: chapter);
        },
        separatorBuilder: (context, index) => const SizedBox(height: 20),
      ),
    );
  }
}
