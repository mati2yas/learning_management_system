import 'package:flutter_riverpod/flutter_riverpod.dart';

final paidScreenTabIndexProv =
    StateNotifierProvider<CurrentCourseIdController, int>((ref) {
  return CurrentCourseIdController();
});

class CurrentCourseIdController extends StateNotifier<int> {
  CurrentCourseIdController() : super(0);
  void changeTabIndex(int newIndex) {
    state = newIndex;
  }
}
