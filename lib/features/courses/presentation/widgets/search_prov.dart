part of 'search_courses_screen.dart';


final searchCoursesProvider =
    AsyncNotifierProvider<SearchCoursesNotifier, List<Course>>(SearchCoursesNotifier.new);

class SearchCoursesNotifier extends AsyncNotifier<List<Course>> {
  @override
  Future<List<Course>> build() async {
    return [];
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
