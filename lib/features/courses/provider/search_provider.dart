import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/courses/provider/courses_provider.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');
final searchResultsProvider = FutureProvider<List<Course>>((ref) async {
  final searchQuery = ref.watch(searchQueryProvider);
  final courseNotifier = ref.watch(allCoursesApiProvider.notifier);
  return courseNotifier.searchCourses(searchQuery);
});
