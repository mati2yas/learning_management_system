import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/features/home/data_source/home_data_source.dart';

final homeDataSourceProvider = Provider<HomeDataSource>((ref) {
  return HomeDataSource(DioClient.instance);
});
