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
    final courseId = ref.watch(currentCourseIdProvider);
    return fetchCourseChapters(courseId);
  }

  Future<List<Chapter>> fetchCourseChapters(String courseId) async {
    try {
      final courseChapters = await _repository.fetchCourseChapters(courseId);
      return courseChapters;
    } catch (e) {
      rethrow;
    }
  }
}
