import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/features/auth_status_registration/data_source/check_authed_data_source.dart';

final authStatusRepositoryProvider = Provider((ref) {
  final dataSource = ref.watch(authStatusDataSourceProvider);
  return AuthStatusRepository(dataSource);
});

class AuthStatusRepository {
  final AuthStatusDataSource _dataSource;

  AuthStatusRepository(this._dataSource);

  Future<void> clearAuthStatus() {
    return _dataSource.clearAuthStatus();
  }

  Future<AuthStatus> getAuthStatus() {
    return _dataSource.getAuthStatus();
  }

  setAuthStatus(AuthStatus authStatus) {
    return _dataSource.setAuthStatus(authStatus);
  }
}
