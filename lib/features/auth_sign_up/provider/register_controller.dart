import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/register_repository.dart';
import 'register_repository_provider.dart';

final registerControllerProvider =
    StateNotifierProvider<RegisterController, RegisterState>(
  (ref) => RegisterController(ref.watch(registerRepositoryProvider)),
);

class RegisterController extends StateNotifier<RegisterState> {
  final RegisterRepository _repository;

  RegisterController(this._repository) : super(RegisterState());

  Future<void> registerUser() async {
    try {
      await _repository.register(
        name: state.name,
        username: state.username,
        email: state.email,
        password: state.password,
      );
    } catch (e) {
      rethrow;
    }
  }

  void updateName(String value) {
    state = state.copyWith(name: value);
  }

  void updatePassword(String value) {
    state = state.copyWith(password: value);
  }

  void updateEmail(String value) {
    state = state.copyWith(email: value);
  }


}

class RegisterState {
  final String name;
  final String username;
  final String email;
  final String password;

  RegisterState({
    this.name = '',
    this.username = '',
    this.email = '',
    this.password = '',
  });

  RegisterState copyWith({
    String? name,
    String? username,
    String? email,
    String? password,
  }) {
    return RegisterState(
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
