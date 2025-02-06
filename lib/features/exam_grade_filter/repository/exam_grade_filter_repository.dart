import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/connectivity/connectivity_service.dart';
import 'package:lms_system/features/exam_grade_filter/data_source/exam_grade_filter_data_source.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';

final examGradeFilterRepositoryProvider =
    Provider<ExamGradeFilterRepository>((ref) {
  return ExamGradeFilterRepository(
    ref.watch(examGradeFilterDataSourceProvider),
    ref.watch(connectivityServiceProvider),
  );
});

class ExamGradeFilterRepository {
  final ExamGradeFilterDataSource _dataSource;
  final ConnectivityService _connectivityService;
  ExamGradeFilterRepository(this._dataSource, this._connectivityService);

  Future<List<ExamGrade>> fetchExamGrades(int examyearId) async {
    if (!await _connectivityService.hasConnection()) {
      throw Exception("No internet connection");
    }
    return await _dataSource.fetchExamGrades(examyearId);
  }
}
