import 'package:lms_system/features/shared/model/shared_course_model.dart';
import 'package:lms_system/features/requests/data_source/requests_data_source.dart';
import 'package:riverpod/riverpod.dart';

final requestsDataSourceProvider = Provider<RequestsDataSource>((ref) {
  return RequestsDataSource();
});

final requestsProvider =
    StateNotifierProvider<RequestsNotifier, List<Course>>((ref) {
  final dataSource = ref.read(requestsDataSourceProvider);
  return RequestsNotifier(dataSource);
});

class RequestsNotifier extends StateNotifier<List<Course>> {
  final RequestsDataSource dataSource;

  RequestsNotifier(this.dataSource) : super([]) {
    loadData();
  }

  void removeAll() {
    state = [];
  }

  (String, List<Course>) addOrRemoveCourse(Course course) {
    if (state.contains(course)) {
      state = state.where((c) => c != course).toList();
      return ("removed", state);
    }

    state = [course, ...state];
    return ("added", state);
  }

  void loadData() {
    state = dataSource.fetchAddedCourses();
  }
}
