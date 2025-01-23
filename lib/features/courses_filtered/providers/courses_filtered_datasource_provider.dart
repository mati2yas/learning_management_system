import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/features/courses_filtered/data_source/courses_filtered_data_source.dart';

final coursesFilteredDataSourceProvider =
    Provider<CoursesFilteredDataSource>((ref) {
  return CoursesFilteredDataSource(DioClient.instance);
});
