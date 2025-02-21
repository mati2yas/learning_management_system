import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';

final courseSubTrackProvider = StateNotifierProvider<CourseSubTrackNotifier, Course>((ref)=> CourseSubTrackNotifier());

class CourseSubTrackNotifier extends StateNotifier<Course> {
  CourseSubTrackNotifier() : super(Course.initial());

  void changeCurrentCourse(Course course) {
    state = course;
  }
}
