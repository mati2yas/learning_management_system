import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentExamCourseIdProvider =
    StateNotifierProvider<CurrentExamCourseIdController, int>((ref) {
  return CurrentExamCourseIdController();
});

class CurrentExamCourseIdController extends StateNotifier<int> {
  CurrentExamCourseIdController() : super(0);
  void changeCourseId(int courseId) {
    state = courseId;
  }
}
