import 'package:lms_system/core/utils/connectivity/connectivity_service.dart';
import 'package:lms_system/features/auth_login/data_source/login_data_source.dart';

class LoginRepository {
  final LoginDataSource _dataSource;
  final ConnectivityService _connectivityService;

  LoginRepository(this._dataSource, this._connectivityService);

  Future<void> login({
    required String email,
    required String password,
  }) {
    return _dataSource.loginUser(
      email: email,
      password: password,
    );
  }
}
