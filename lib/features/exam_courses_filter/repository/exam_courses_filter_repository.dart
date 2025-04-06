import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/utils/connectivity/connectivity_service.dart';
import 'package:lms_system/features/exam_courses_filter/data_source/exam_courses_filter_data_source.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';

final examCoursesFilterRepositoryProvider =
    Provider<ExamCoursesFilterRepository>((ref) {
  return ExamCoursesFilterRepository(
    ref.watch(examFilterDataSourceProvider),
    ref.watch(connectivityServiceProvider),
  );
});

class ExamCoursesFilterRepository {
  final ExamCoursesFilterDataSource _dataSource;
  final ConnectivityService _connectivityService;
  ExamCoursesFilterRepository(this._dataSource, this._connectivityService);

  Future<List<ExamCourse>> fetchExamCourses(ExamType examType) async {
    if (!await _connectivityService.hasConnection()) {
      throw Exception("No internet connection");
    }
    return await _dataSource.fetchExamCourses(examType);
  }
}
