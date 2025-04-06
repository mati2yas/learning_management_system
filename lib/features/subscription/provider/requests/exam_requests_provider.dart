import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/features/exams/model/exam_year.dart';

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
    if (state.isEmpty) {
      loadData();
    }
  }

  (String, List<ExamYear>) addOrRemoveExamYear(
      ExamYear examYear, ExamType examType) {
    debugPrint(
        "in examReqProvider's addOrRemove: exam year's sheet id: ${examYear.examSheetId}");
    final newState = [...state];
    if (newState.contains(examYear)) {
      newState.remove(examYear);
      state = newState;
      return ("removed from cart", state);
    }

    state = [examYear, ...state];
    return ("added to cart", state);
  }

  void loadData() {
    state = dataSource.fetchAddedExam();
  }

  void removeAll() {
    state = [];
  }
}
