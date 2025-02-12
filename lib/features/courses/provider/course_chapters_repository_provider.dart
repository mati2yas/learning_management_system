import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/connectivity/connectivity_service.dart';
import 'package:lms_system/features/courses/data_source/course_chapters_data_source.dart';
import 'package:lms_system/features/courses/repository/course_chapters_repository.dart';

final courseChaptersRepositoryProvider =
    Provider<CourseChaptersRepository>((ref) {
  return CourseChaptersRepository(
    ref.watch(courseChaptersDataSourceProvider),
    ref.watch(connectivityServiceProvider),
  );
});
