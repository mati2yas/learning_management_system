import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/exam_year_filter/provider/current_exam_type_provider.dart';
import 'package:lms_system/features/exam_year_filter/repository/exam_year_filter_repository.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';

final examYearFilterApiProvider =
    AsyncNotifierProvider<ExamYearFilterNotifier, List<ExamCourse>>(
  () {
    final container = ProviderContainer(
      overrides: [
        examYearFilterRepositoryProvider,
      ],
    );
    return container.read(examYearFilterNotifierProvider);
  },
);
final examYearFilterNotifierProvider = Provider((ref) =>
    ExamYearFilterNotifier(ref.read(examYearFilterRepositoryProvider)));

class ExamYearFilterNotifier extends AsyncNotifier<List<ExamCourse>> {
  final ExamYearFilterRepository _repository;

  ExamYearFilterNotifier(this._repository);

  @override
  Future<List<ExamCourse>> build() {
    return fetchExamYears();
  }

  Future<List<ExamCourse>> fetchExamYears() async {
    var currentExamType = ref.read(currentExamTypeProvider);
    state = const AsyncLoading();
    try {
      final examYears = await _repository.fetchExamYears(currentExamType);
      state = AsyncData(examYears);
      return examYears;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }
}
