import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/exam_grade_filter/repository/exam_grade_filter_repository.dart';
import 'package:lms_system/features/exam_year_filter/provider/current_exam_year_provider.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';
import 'package:lms_system/features/exams/provider/current_exam_course_id.dart';

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
    int yearId = ref.read(currentExamYearIdProvider);
    int courseId = ref.read(currentExamCourseIdProvider);
    state = const AsyncValue.loading();
    try {
      final examGrades = await _repository.fetchExamGrades(yearId: yearId, courseId: courseId);
      state = AsyncValue.data(examGrades);
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
    return state.value ?? [];
  }
}
