import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/features/exams/model/exam_year.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';

import '../../data_source/requests/exam_request_datsource.dart';

final examRequestsDataSourceProvider = Provider<ExamRequestsDataSource>((ref) {
  return ExamRequestsDataSource();
});

final examRequestsProvider =
    StateNotifierProvider<ExamRequestsNotifier, List<ExamYear>>((ref) {
  final dataSource = ref.read(examRequestsDataSourceProvider);
  return ExamRequestsNotifier(dataSource);
});

class ExamRequestsNotifier extends StateNotifier<List<ExamYear>> {
  final ExamRequestsDataSource dataSource;

  ExamRequestsNotifier(this.dataSource) : super([]) {
    loadData();
  }

  String addOrRemoveExamYear(ExamYear examYear, ExamType examType) {
    if (state.contains(examYear)) {
      state = state.where((c) => c != examYear).toList();
      return "removed from cart";
    }

    state = [examYear, ...state];
    return "added to cart";
  }

  void loadData() {
    state = dataSource.fetchAddedExam();
  }

  void removeAll() {
    state = [];
  }
}
