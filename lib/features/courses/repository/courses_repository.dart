import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/connectivity/connectivity_service.dart';
import 'package:lms_system/features/courses/data_source/courses_data_source.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';

final coursesRepositoryProvider = Provider<CoursesRepository>((ref) {
  return CoursesRepository(
    ref.watch(courseDataSourceProvider),
    ref.watch(connectivityServiceProvider),
  );
});

class CoursesRepository {
  final CourseDataSource _dataSource;
  final ConnectivityService _connectivityService;

  CoursesRepository(this._dataSource, this._connectivityService);
  Future<void> fetchAllCourses() async {
    _dataSource.fetchCourses();
  }

  Future<List<Course>> fetchCourses() async {
    if (!await _connectivityService.hasConnection()) {
      throw Exception("No internet connection");
    }
    return _dataSource.fetchCourses();
  }
}
