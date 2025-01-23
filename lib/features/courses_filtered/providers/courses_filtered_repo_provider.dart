import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/connectivity/connectivity_service.dart';
import 'package:lms_system/features/courses_filtered/providers/courses_filtered_datasource_provider.dart';
import 'package:lms_system/features/courses_filtered/repository/courses_filtered_repository.dart';

final coursesFilteredRepositoryProvider =
    Provider<CoursesFilteredRepository>((ref) {
  return CoursesFilteredRepository(
    ref.watch(coursesFilteredDataSourceProvider),
    ref.watch(connectivityServiceProvider),
  );
});
