import 'package:lms_system/core/utils/connectivity/connectivity_service.dart';

import '../data_source/register_data_source.dart';

class RegisterRepository {
  final RegisterDataSource _dataSource;

  final ConnectivityService _connectivityService;

  RegisterRepository(this._dataSource, this._connectivityService);

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) {
    return _dataSource.registerUser(
      name: name,
      email: email,
      password: password,
    );
  }
}
