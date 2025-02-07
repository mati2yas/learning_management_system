import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/exam_grade_filter/repository/exam_grade_filter_repository.dart';
import 'package:lms_system/features/exam_year_filter/provider/current_exam_year_provider.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';

final examGradeFilterApiProvider =
    AsyncNotifierProvider<ExamGradeFilterNotifier, List<ExamGrade>>(
  () {
    final container = ProviderContainer(
      overrides: [
        examGradeFilterRepositoryProvider,
      ],
    );
    return container.read(examGradeFilterNotifierProvider);
  },
);
final examGradeFilterNotifierProvider = Provider((ref) =>
    ExamGradeFilterNotifier(ref.read(examGradeFilterRepositoryProvider)));

class ExamGradeFilterNotifier extends AsyncNotifier<List<ExamGrade>> {
  final ExamGradeFilterRepository _repository;

  ExamGradeFilterNotifier(this._repository);
  @override
  Future<List<ExamGrade>> build() {
    return fetchExamGrades();
  }

  Future<List<ExamGrade>> fetchExamGrades() async {
    int id = ref.read(currentExamYearIdProvider);
    try {
      final examGrades = await _repository.fetchExamGrades(id);
      return examGrades;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }
}
