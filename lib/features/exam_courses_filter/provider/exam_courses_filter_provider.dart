import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/exam_courses_filter/provider/current_exam_type_provider.dart';
import 'package:lms_system/features/exam_courses_filter/repository/exam_courses_filter_repository.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';

final examCoursesFilterApiProvider =
    AsyncNotifierProvider<ExamCoursesFilterNotifier, List<ExamCourse>>(
  () {
    final container = ProviderContainer(
      overrides: [
        examCoursesFilterRepositoryProvider,
      ],
    );
    return container.read(examCoursesFilterNotifierProvider);
  },
);
final examCoursesFilterNotifierProvider = Provider((ref) =>
    ExamCoursesFilterNotifier(ref.read(examCoursesFilterRepositoryProvider)));

class ExamCoursesFilterNotifier extends AsyncNotifier<List<ExamCourse>> {
  final ExamCoursesFilterRepository _repository;

  ExamCoursesFilterNotifier(this._repository);

  @override
  Future<List<ExamCourse>> build() {
    return fetchExamCourses();
  }

  Future<List<ExamCourse>> fetchExamCourses() async {
    var currentExamType = ref.read(currentExamTypeProvider);
    state = const AsyncLoading();
    try {
      final examYears = await _repository.fetchExamCourses(currentExamType);
      state = AsyncData(examYears);
      return examYears;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }
}
