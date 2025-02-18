import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/courses/provider/course_chapters_repository_provider.dart';
import 'package:lms_system/features/courses/provider/current_course_id.dart';
import 'package:lms_system/features/shared/model/chapter.dart';

import '../repository/course_chapters_repository.dart';

final courseChaptersNotifierProvider = Provider(
    (ref) => CourseContentNotifier(ref.read(courseChaptersRepositoryProvider)));

final courseChaptersProvider =
    AsyncNotifierProvider<CourseContentNotifier, List<Chapter>>(() {
  final container = ProviderContainer(overrides: [
    courseChaptersRepositoryProvider,
    currentCourseIdProvider,
  ]);
  return container.read(courseChaptersNotifierProvider);
});

class CourseContentNotifier extends AsyncNotifier<List<Chapter>> {
  final CourseChaptersRepository _repository;

  CourseContentNotifier(this._repository);

  @override
  Future<List<Chapter>> build() async {
    return fetchCourseChapters();
  }

  Future<List<Chapter>> fetchCourseChapters() async {
    final courseId = ref.watch(currentCourseIdProvider);
    state = const AsyncValue.loading();
    try {
      final courseChapters = await _repository.fetchCourseChapters(courseId);
      state = AsyncValue.data(courseChapters);
      return courseChapters;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }
}
