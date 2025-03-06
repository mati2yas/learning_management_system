import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/requests/data_source/requests_data_source.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';

final courseRequestsDataSourceProvider = Provider<RequestsDataSource>((ref) {
  return RequestsDataSource();
});

final courseRequestsProvider =
    StateNotifierProvider<CourseRequestsNotifier, List<Course>>((ref) {
  final dataSource = ref.read(courseRequestsDataSourceProvider);
  return CourseRequestsNotifier(dataSource);
});

class CourseRequestsNotifier extends StateNotifier<List<Course>> {
  final RequestsDataSource dataSource;

  CourseRequestsNotifier(this.dataSource) : super([]) {
    loadData();
  }

  (String, List<Course>) addOrRemoveCourse(Course course) {
    if (state.contains(course)) {
      state = state.where((c) => c != course).toList();
      return ("removed from cart", state);
    }

    state = [course, ...state];
    return ("added to cart", state);
  }

  void loadData() {
    state = dataSource.fetchAddedCourses();
  }

  void removeAll() {
    state = [];
  }
}
