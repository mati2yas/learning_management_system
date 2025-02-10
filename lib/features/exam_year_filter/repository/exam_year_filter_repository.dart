import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/connectivity/connectivity_service.dart';
import 'package:lms_system/features/exam_year_filter/data_source/exam_year_filter_data_source.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';

final examYearFilterRepositoryProvider =
    Provider<ExamYearFilterRepository>((ref) {
  return ExamYearFilterRepository(
    ref.watch(examFilterDataSourceProvider),
    ref.watch(connectivityServiceProvider),
  );
});

class ExamYearFilterRepository {
  final ExamYearFilterDataSource _dataSource;
  final ConnectivityService _connectivityService;
  ExamYearFilterRepository(this._dataSource, this._connectivityService);

  Future<List<ExamCourse>> fetchExamYears(ExamType examType) async {
    if (!await _connectivityService.hasConnection()) {
      throw Exception("No internet connection");
    }
    return await _dataSource.fetchExamYears(examType);
  }
}
