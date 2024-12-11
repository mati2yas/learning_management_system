import 'package:lms_system/features/shared_course/model/chapter.dart';

class Course {
  final String title, desc, image;
  final int topics, saves, likes;
  final double progress;
  final List<Chapter> chapters;
  String? streamOrDepartment;
  bool subscribed;
  bool saved, liked;
  Course({
    required this.title,
    required this.desc,
    required this.topics,
    required this.saves,
    required this.likes,
    required this.image,
    this.progress = 0.0,
    this.subscribed = false,
    this.saved = false,
    this.liked = false,
    required this.chapters,
    this.streamOrDepartment,
  });
}
