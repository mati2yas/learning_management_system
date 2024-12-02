import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';

final loginControllerProvider =
    StateNotifierProvider<LoginController, LoginState>(
  (ref) => LoginController(),
);

class LoginController extends StateNotifier<LoginState> {
  LoginController() : super(LoginState());

  void updatePassword(String value) {
    state = state.copyWith(password: value);
  }

  void updatePhone(String value) {
    state = state.copyWith(phone: value);
  }
}

class LoginState {
  final String phone;
  final String password;

  LoginState({
    this.phone = '',
    this.password = '',
  });

  LoginState copyWith({
    String? phone,
    String? password,
  }) {
    return LoginState(
      phone: phone ?? this.phone,
      password: password ?? this.password,
    );
  }
}
