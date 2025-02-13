import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/connectivity/connectivity_service.dart';
import 'package:lms_system/features/auth_login/data_source/login_data_source.dart';

final loginRepositoryProvider = Provider<LoginRepository>((ref) {
  return LoginRepository(
    ref.watch(loginDataSourceProvider),
    ref.watch(connectivityServiceProvider),
  );
});

class LoginRepository {
  final LoginDataSource _dataSource;
  final ConnectivityService _connectivityService;

  LoginRepository(this._dataSource, this._connectivityService);

  Future<void> login({
    required String email,
    required String password,
  }) async {
    if (!await _connectivityService.hasConnection()) {
      throw Exception("No internet connection");
    }
    return await _dataSource.loginUser(
      email: email,
      password: password,
    );
  }
}
