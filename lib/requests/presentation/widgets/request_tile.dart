import 'package:flutter/material.dart';
import 'package:lms_system/features/shared_course/model/shared_course_model.dart';

class RequestTile extends StatelessWidget {
  final Course course;

  final TextTheme textTh;
  const RequestTile({
    super.key,
    required this.course,
    required this.textTh,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(6),
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(6),
            ),
          ),
          child: Image.asset(
            "assets/images/${course.image}",
            fit: BoxFit.cover,
          ),
        ),
        title: Text(course.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
              width: 220,
              child: Row(
                children: [
                  const SizedBox(width: 5),
                  Text(
                    "${course.progress.toInt()} %",
                    style: textTh.labelMedium,
                  ),
                ],
              ),
            ),
            Text("${course.topics} topics"),
          ],
        ),
      ),
    );
  }
}
