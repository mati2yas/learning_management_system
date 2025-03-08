import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';

import '../../data_source/requests/course_request_datasource.dart';

final courseRequestsDataSourceProvider =
    Provider<CourseRequestsDataSource>((ref) {
  return CourseRequestsDataSource();
});

final courseRequestsProvider =
    StateNotifierProvider<CourseRequestsNotifier, List<Course>>((ref) {
  final dataSource = ref.read(courseRequestsDataSourceProvider);
  return CourseRequestsNotifier(dataSource);
});

class CourseRequestsNotifier extends StateNotifier<List<Course>> {
  final CourseRequestsDataSource dataSource;

  CourseRequestsNotifier(this.dataSource) : super([]) {
    loadData();
  }

  Future<(String, List<Course>)> addOrRemoveCourse(Course course) async {
    if (state.contains(course)) {
      state = state.where((c) => c != course).toList();
      return ("removed from cart", state);
    }

    state = [course, ...state];
    //await dataSource.setCoursesToLocal(state);
    return ("added to cart", state);
  }

  void loadData() async {
    state = await dataSource.fetchCoursesFromLocal();
  }

  void removeAll() {
    state = [];
  }
}
