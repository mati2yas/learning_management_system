import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/utils/storage_service.dart';

final authStatusDataSourceProvider = Provider((ref) {
  return AuthStatusDataSource(SecureStorageService());
});

class AuthStatusDataSource {
  final SecureStorageService _storageService;

  AuthStatusDataSource(this._storageService);

  Future<void> clearAuthStatus() async {
    await _storageService.deleteUser(); // Assuming the user has an id of 1
  }

  Future<AuthStatus> getAuthStatus() async {
    final user = await _storageService.getUserFromStorage();
    final authStat = await _storageService.getUserAuthedStatus();

    if (user == null) {
      return AuthStatus.notAuthed;
    }
    return authStat;
  }

  Future<void> setAuthStatus(AuthStatus authStatus) async {
    await _storageService.setUserAuthedStatus(authStatus);
  }
}
