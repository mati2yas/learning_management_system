import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/connectivity/connectivity_service.dart';
import 'package:lms_system/features/paid_courses/data_source/paid_courses_data_source.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';

final paidCoursesRepositoryProvider = Provider<PaidCoursesRepository>((ref) {
  return PaidCoursesRepository(
    ref.watch(paidCoursesDataSourceProvider),
    ref.watch(connectivityServiceProvider),
  );
});

class PaidCoursesRepository {
  final PaidCoursesDataSource _dataSource;
  final ConnectivityService _connectivityService;

  PaidCoursesRepository(this._dataSource, this._connectivityService);

  Future<List<Course>> fetchPaidCourses() async {
    if (!await _connectivityService.hasConnection()) {
      throw Exception("No internet connection");
    }
    return _dataSource.fetchPaidCourses();
  }

  Future<Response> toggleCourseLiked(Course course) async {
    if (!await _connectivityService.hasConnection()) {
      throw Exception("No Internet");
    }
    return await _dataSource.toggleCourseLiked(course);
  }

  Future<Response> toggleCourseSaved(Course course) async {
    if (!await _connectivityService.hasConnection()) {
      throw Exception("No Internet");
    }
    return await _dataSource.toggleCourseSaved(course);
  }
}
