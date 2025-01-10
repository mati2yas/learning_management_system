import 'package:lms_system/features/auth_login/data_source/login_data_source.dart';

class LoginRepository {
  final LoginDataSource _dataSource;

  LoginRepository(this._dataSource);

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
