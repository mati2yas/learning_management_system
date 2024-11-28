import 'package:flutter/material.dart';
import 'package:lms_system/src/shared_course/model/shared_course_model.dart';

import 'custom_listtile.dart';

class CoursesListWidget extends StatelessWidget {
  final List<Course> courses;
  final TextTheme textTh;
  const CoursesListWidget({
    super.key,
    required this.courses,
    required this.textTh,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: courses.length,
      itemBuilder: (_, index) =>
          ListTilewidget(course: courses[index], textTh: textTh),
      separatorBuilder: (_, ind) => const SizedBox(height: 15),
    );
  }
}
