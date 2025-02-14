import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/connectivity/connectivity_service.dart';
import 'package:lms_system/core/utils/db_service.dart';
import 'package:lms_system/core/utils/dio_client.dart';

import '../data_source/register_data_source.dart';
import '../repository/register_repository.dart';

final registerDataSourceProvider = Provider<RegisterDataSource>((ref) {
  return RegisterDataSource(
    DioClient.instance,
    DatabaseService(),
  );
});

final registerRepositoryProvider = Provider<RegisterRepository>((ref) {
  return RegisterRepository(
    ref.watch(registerDataSourceProvider),
    ref.watch(connectivityServiceProvider),
  );
});
