import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/courses/provider/courses_provider.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';

final searchCoursesProvider =
    AsyncNotifierProvider<SearchCoursesNotifier, List<Course>>(
        SearchCoursesNotifier.new);

class SearchCoursesNotifier extends AsyncNotifier<List<Course>> {
  @override
  Future<List<Course>> build() async {
    return [];
  }

  void clearSearch() {
    state = const AsyncData([]);
  }

  Future<void> searchCourses(String query) async {
    if (query.trim().isEmpty) {
      state = const AsyncData([]);
      return;
    }

    state = const AsyncLoading();
    try {
      final result =
          await ref.read(allCoursesApiProvider.notifier).searchCourses(query);
      state = AsyncData(result);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
