import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentCourseIdProvider =
    StateNotifierProvider<CurrentCourseIdController, String>((ref) {
  return CurrentCourseIdController();
});

class CurrentCourseIdController extends StateNotifier<String> {
  CurrentCourseIdController() : super("0");
  void changeCourseId(String newId) {
    state = newId;
  }
}