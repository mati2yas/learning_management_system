import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/courses/provider/course_repository_provider.dart';
import 'package:lms_system/features/courses/repository/courses_repository.dart';

import '../../shared/model/shared_course_model.dart';

final allCoursesApiProvider =
    AsyncNotifierProvider<CourseNotifier, List<Course>>(() {
  final container = ProviderContainer(
    overrides: [
      courseRepositoryProvider,
    ],
  );
  return container.read(courseNotifierProvider);
});
final courseNotifierProvider =
    Provider((ref) => CourseNotifier(ref.read(courseRepositoryProvider)));

// StateNotifier for managing course data
class CourseNotifier extends AsyncNotifier<List<Course>> {
  final CoursesRepository _repository;

  CourseNotifier(this._repository);
  @override
  Future<List<Course>> build() async {
    return loadCourses();
  }

  Future<List<Course>> loadCourses() async {
    state = const AsyncValue.loading();
    try {
      final courses = await _repository.fetchCourses();
      state = AsyncData(courses);
      return courses;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  Future<List<Course>> searchCourses(String searchQuery) async {
    await Future.delayed(const Duration(seconds: 2));
    return [];
  }

  void toggleLiked(Course course) {
    update((state) {
      return state.map((c) {
        if (c == course) {
          return Course(
            id: c.id,
            category: c.category,
            title: c.title,
            topics: c.topics,
            saves: c.saves,
            likes: c.likes + (c.liked ? -1 : 1),
            image: c.image,
            saved: c.saved,
            liked: !c.liked,
            price: c.price,
            subscribed: c.subscribed,
            chapters: c.chapters,
          );
        }
        return c;
      }).toList();
    });
  }

  void toggleSaved(Course course) {
    update((state) {
      return state.map((c) {
        if (c == course) {
          return Course(
            id: c.id,
            title: c.title,
            category: c.category,
            topics: c.topics,
            saves: c.saves + (c.saved ? -1 : 1),
            likes: c.likes,
            liked: c.liked,
            image: c.image,
            saved: !c.saved,
            subscribed: c.subscribed,
            price: c.price,
            chapters: c.chapters,
          );
        }
        return c;
      }).toList();
    });
  }

  void toggleSubscribed(Course course) {
    update((state) {
      return state.map((c) {
        if (c == course) {
          return Course(
            id: c.id,
            category: c.category,
            title: c.title,
            topics: c.topics,
            saves: c.saves,
            likes: c.likes,
            image: c.image,
            saved: c.saved,
            subscribed: !c.subscribed,
            price: c.price,
            chapters: c.chapters,
          );
        }
        return c;
      }).toList();
    });
  }
}
