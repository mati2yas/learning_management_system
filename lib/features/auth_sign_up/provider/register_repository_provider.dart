import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/dio_client.dart';

import '../data_source/register_data_source.dart';
import '../repository/register_repository.dart';

final registerDataSourceProvider = Provider<RegisterDataSource>((ref) {
  return RegisterDataSource(DioClient.instance);
});

final registerRepositoryProvider = Provider<RegisterRepository>((ref) {
  return RegisterRepository(ref.watch(registerDataSourceProvider));
});
