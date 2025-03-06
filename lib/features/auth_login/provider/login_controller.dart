import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/features/auth_login/repository/login_repository.dart';

final loginControllerProvider =
    StateNotifierProvider<LoginController, LoginState>(
  (ref) => LoginController(ref.watch(loginRepositoryProvider)),
);

class LoginController extends StateNotifier<LoginState> {
  final LoginRepository _repository;
  LoginController(this._repository) : super(LoginState());

  Future<void> loginUser() async {
    state = state.copyWith(apiState: ApiState.busy);
    try {
      await _repository.login(
        email: state.email,
        password: state.password,
      );

      state = state.copyWith(apiState: ApiState.idle);
    } catch (e) {
      state = state.copyWith(apiState: ApiState.error);
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
  final ApiState apiStatus;

  LoginState({
    this.email = '',
    this.password = '',
    this.apiStatus = ApiState.idle,
  });

  LoginState copyWith({
    String? email,
    String? password,
    ApiState? apiState,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      apiStatus: apiState ?? apiStatus,
    );
  }
}
