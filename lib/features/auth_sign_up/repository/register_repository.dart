import '../data_source/register_data_source.dart';

class RegisterRepository {
  final RegisterDataSource _dataSource;

  RegisterRepository(this._dataSource);

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
