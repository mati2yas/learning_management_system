
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/auth_sign_up/model/register_state.dart';
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


