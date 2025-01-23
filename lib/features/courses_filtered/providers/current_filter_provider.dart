import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentCourseFilterProvider =
    StateNotifierProvider<CurrentCourseFilterNotifier, String>((ref) {
  return CurrentCourseFilterNotifier("lower_grades");
});

class CurrentCourseFilterNotifier extends StateNotifier<String> {
  final String filter;
  CurrentCourseFilterNotifier(this.filter) : super(filter);

  void changeFilter(String newFilter) {
    state = newFilter;
  }
}
