import 'package:lms_system/features/shared_course/model/chapter.dart';

class Course {
  final String title, desc, image;
  final int topics, saves;
  final double progress;
  final List<Chapter> chapters;
  bool subscribed;
  bool saved;
  Course({
    required this.title,
    required this.desc,
    required this.topics,
    required this.saves,
    required this.image,
    this.progress = 0.0,
    this.subscribed = false,
    this.saved = false,
    required this.chapters,
  });
}
