import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/connectivity/connectivity_service.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/features/auth_login/data_source/login_data_source.dart';
import 'package:lms_system/features/auth_login/repository/login_repository.dart';

final loginDataSourceProvider = Provider<LoginDataSource>((ref) {
  return LoginDataSource(DioClient.instance);
});

final loginRepositoryProvider = Provider<LoginRepository>((ref) {
  return LoginRepository(
    ref.watch(loginDataSourceProvider),
    ref.watch(connectivityServiceProvider),
  );
});
