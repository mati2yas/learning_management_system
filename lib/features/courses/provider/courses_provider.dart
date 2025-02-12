import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/courses/provider/course_repository_provider.dart';
import 'package:lms_system/features/courses/repository/courses_repository.dart';
import 'package:riverpod/riverpod.dart';

import '../../shared/model/shared_course_model.dart';

final coursesProvider =
    StateNotifierProvider<CourseNotifier, List<Course>>((ref) {
  return CourseNotifier(ref.watch(courseRepositoryProvider));
});

// StateNotifier for managing course data
class CourseNotifier extends StateNotifier<List<Course>> {
  final CoursesRepository _repository;

  CourseNotifier(this._repository) : super([]) {
    loadCourses();
  }

  Future<void> loadCourses() async {
    state = await _repository.fetchCourses();
  }

  void toggleLiked(Course course) {
    state = state.map((c) {
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
  }

  void toggleSaved(Course course) {
    state = state.map((c) {
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
  }

  void toggleSubscribed(Course course) {
    state = state.map((c) {
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
  }
}
