import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/courses/provider/courses_provider.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';

final searchQueryProvider =
    StateNotifierProvider<QueryNotifier, String>((ref) => QueryNotifier());

final searchResultsProvider = FutureProvider<List<Course>>((ref) async {
  final searchQuery = ref.watch(searchQueryProvider);
  final courseNotifier = ref.watch(allCoursesApiProvider.notifier);
  return courseNotifier.searchCourses(searchQuery);
});

class QueryNotifier extends StateNotifier<String> {
  QueryNotifier() : super("");

  void updateQuery(String query) {
    state = query;
    //debugPrint("updated query: $state");
  }
}
