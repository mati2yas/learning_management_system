import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/exams/model/exam_year.dart';
import 'package:lms_system/features/requests/data_source/requests_data_source.dart';

final courseRequestsDataSourceProvider = Provider<RequestsDataSource>((ref) {
  return RequestsDataSource();
});

final courseRequestsProvider =
    StateNotifierProvider<ExamRequestsNotifier, List<ExamYear>>((ref) {
  final dataSource = ref.read(courseRequestsDataSourceProvider);
  return ExamRequestsNotifier(dataSource);
});

class ExamRequestsNotifier extends StateNotifier<List<ExamYear>> {
  final RequestsDataSource dataSource;

  ExamRequestsNotifier(this.dataSource) : super([]) {
    loadData();
  }

  (String, List<ExamYear>) addOrRemoveExamYear(ExamYear examYear) {
    if (state.contains(examYear)) {
      state = state.where((c) => c != examYear).toList();
      return ("removed from cart", state);
    }

    state = [examYear, ...state];
    return ("added to cart", state);
  }

  void loadData() {
    state = dataSource.fetchAddedExams();
  }

  void removeAll() {
    state = [];
  }
}
