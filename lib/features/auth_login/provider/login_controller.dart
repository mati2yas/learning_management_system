import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/auth_login/repository/login_repository.dart';

final loginControllerProvider =
    StateNotifierProvider<LoginController, LoginState>(
  (ref) => LoginController(ref.watch(loginRepositoryProvider)),
);

class LoginController extends StateNotifier<LoginState> {
  final LoginRepository _repository;
  LoginController(this._repository) : super(LoginState());

  Future<void> loginUser() async {
    try {
      await _repository.login(
        email: state.email,
        password: state.password,
      );
    } catch (e) {
      rethrow;
    }
  }

  void updateEmail(String value) {
    state = state.copyWith(email: value);
  }

  void updatePassword(String value) {
    state = state.copyWith(password: value);
  }
}

class LoginState {
  final String email;
  final String password;

  LoginState({
    this.email = '',
    this.password = '',
  });

  LoginState copyWith({
    String? email,
    String? password,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
