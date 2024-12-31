import 'package:lms_system/features/shared/model/shared_course_model.dart';
import 'package:lms_system/requests/data_source/requests_data_source.dart';
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

  String addOrRemoveCourse(Course course) {
    if (state.contains(course)) {
      state = state.where((c) => c != course).toList();
      return "removed";
    }

    state = [course, ...state];
    return "added";
  }

  void loadData() {
    state = dataSource.fetchAddedCourses();
  }
}
