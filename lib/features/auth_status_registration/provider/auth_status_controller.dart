import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/enums.dart';

import '../repository/check_authed_repository.dart';

final authStatusProvider =
    StateNotifierProvider<AuthStatusController, AuthStatus>((ref) {
  final repository = ref.watch(authStatusRepositoryProvider);
  return AuthStatusController(repository);
});

class AuthStatusController extends StateNotifier<AuthStatus> {
  final AuthStatusRepository _repository;

  AuthStatusController(this._repository) : super(AuthStatus.notAuthed);

  Future<AuthStatus> checkAuthStatus() async {
    state = await _repository.getAuthStatus();
    return state;
  }

  Future<void> setAuthStatus(AuthStatus authStatus) async {
    state = authStatus;
    await _repository.setAuthStatus(authStatus);
  }

  Future<void> clearStatus() async {
    await _repository.clearAuthStatus();
    state = AuthStatus.notAuthed; // Reset state
  }
}
