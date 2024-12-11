import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';

import '../../shared_course/model/shared_course_model.dart';
import '../data_source/courses_data_source.dart';

// Provider for the data source
final courseDataSourceProvider = Provider<CourseDataSource>((ref) {
  return CourseDataSource();
});

// Provider for the state notifier
final courseProvider =
    StateNotifierProvider<CourseNotifier, List<Course>>((ref) {
  final dataSource = ref.read(courseDataSourceProvider);
  return CourseNotifier(dataSource);
});

// StateNotifier for managing course data
class CourseNotifier extends StateNotifier<List<Course>> {
  final CourseDataSource dataSource;

  CourseNotifier(this.dataSource) : super([]) {
    loadCourses();
  }

  void loadCourses() {
    state = dataSource.fetchCourses();
  }

  void toggleLiked(Course course) {
    state = state.map((c) {
      if (c == course) {
        return Course(
          title: c.title,
          desc: c.desc,
          topics: c.topics,
          saves: c.saves + (c.saved ? -1 : 1),
          likes: c.likes + (c.liked ? -1 : 1),
          image: c.image,
          saved: !c.saved,
          liked: !c.liked,
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
          title: c.title,
          desc: c.desc,
          topics: c.topics,
          saves: c.saves + (c.saved ? -1 : 1),
          likes: c.likes,
          image: c.image,
          saved: !c.saved,
          subscribed: c.subscribed,
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
          title: c.title,
          desc: c.desc,
          topics: c.topics,
          saves: c.saves,
          likes: c.likes,
          image: c.image,
          saved: c.saved,
          subscribed: !c.subscribed,
          chapters: c.chapters,
        );
      }
      return c;
    }).toList();
  }
}
