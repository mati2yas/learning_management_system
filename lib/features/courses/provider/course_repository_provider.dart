import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/connectivity/connectivity_service.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/features/courses/data_source/courses_data_source.dart';
import 'package:lms_system/features/courses/repository/courses_repository.dart';

final courseDataSourceProvider = Provider<CourseDataSource>((ref) {
  return CourseDataSource(DioClient.instance);
});

final courseRepositoryProvider = Provider<CoursesRepository>((ref) {
  return CoursesRepository(
    ref.watch(courseDataSourceProvider),
    ref.watch(connectivityServiceProvider),
  );
});
