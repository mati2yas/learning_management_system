import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';

final registerControllerProvider =
    StateNotifierProvider<RegisterController, RegisterState>(
  (ref) => RegisterController(),
);

class RegisterController extends StateNotifier<RegisterState> {
  RegisterController() : super(RegisterState());

  void updateName(String value) {
    state = state.copyWith(name: value);
  }

  void updatePassword(String value) {
    state = state.copyWith(password: value);
  }

  void updatePhone(String value) {
    state = state.copyWith(phone: value);
  }

  void updateUsername(String value) {
    state = state.copyWith(username: value);
  }
}

class RegisterState {
  final String name;
  final String username;
  final String phone;
  final String password;

  RegisterState({
    this.name = '',
    this.username = '',
    this.phone = '',
    this.password = '',
  });

  RegisterState copyWith({
    String? name,
    String? username,
    String? phone,
    String? password,
  }) {
    return RegisterState(
      name: name ?? this.name,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      password: password ?? this.password,
    );
  }
}
