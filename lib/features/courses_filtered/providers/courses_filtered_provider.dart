import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/courses_filtered/providers/courses_filtered_repo_provider.dart';
import 'package:lms_system/features/courses_filtered/repository/courses_filtered_repository.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';
import 'package:lms_system/features/wrapper/provider/current_category.dart';

final coursesFilteredNotifierProvider = Provider((ref) =>
    CoursesFilteredNotifier(ref.read(coursesFilteredRepositoryProvider),
        ref.read(currentCategoryProvider)));


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
  final String _categoryFilter;

  CoursesFilteredNotifier(this._repository, this._categoryFilter);
  @override
  Future<List<Course>> build() async {
    return fetchCoursesFiltered(filter: _categoryFilter);
  }

  Future<List<Course>> fetchCoursesFiltered({required String filter}) async {
    try {
      final coursesFiltered = await _repository.fetchCourses(filter: filter);
      return coursesFiltered;
    } catch (e) {
      rethrow;
    }
  }
}
