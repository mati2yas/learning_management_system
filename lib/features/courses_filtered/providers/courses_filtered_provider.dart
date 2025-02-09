import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/courses_filtered/providers/courses_filtered_repo_provider.dart';
import 'package:lms_system/features/courses_filtered/providers/current_filter_provider.dart';
import 'package:lms_system/features/courses_filtered/repository/courses_filtered_repository.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';
import 'package:lms_system/features/wrapper/provider/current_category.dart';

final coursesFilteredNotifierProvider = Provider((ref) =>
    CoursesFilteredNotifier(ref.watch(coursesFilteredRepositoryProvider)));

final coursesFilteredProvider =
    AsyncNotifierProvider<CoursesFilteredNotifier, List<Course>>(() {
  final container = ProviderContainer(overrides: [
    coursesFilteredRepositoryProvider,
    currentCategoryProvider,
  ]);
  return container.read(coursesFilteredNotifierProvider);
});

class CoursesFilteredNotifier extends AsyncNotifier<List<Course>> {
  final CoursesFilteredRepository _repository;

  CoursesFilteredNotifier(this._repository);
  @override
  Future<List<Course>> build() async {
    String filter = ref.read(currentCourseFilterProvider);
    return fetchCoursesFiltered(filter: filter);
  }

  
   Future<List<Course>> fetchCoursesFiltered({required String filter}) async {
    state = const AsyncValue.loading();
    try {
      final coursesFiltered = await _repository.fetchCourses(filter: filter);
      state = AsyncValue.data(coursesFiltered);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
    return state.value ?? [];
  }
}
