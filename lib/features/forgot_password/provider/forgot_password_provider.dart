import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/enums.dart';

import '../repository/forgot_password_repository.dart';

final forgotPasswordControllerProvider =
    StateNotifierProvider<ForgotPasswordController, ForgotPasswordState>(
  (ref) =>
      ForgotPasswordController(ref.watch(forgotPasswordRepositoryProvider)),
);

class ForgotPasswordController extends StateNotifier<ForgotPasswordState> {
  final ForgotPasswordRepository _repository;
  ForgotPasswordController(this._repository) : super(ForgotPasswordState());

  Future<void> forgotPassword() async {
    state = state.copyWith(apiState: ApiState.busy);
    try {
      await _repository.forgotPassword(email: state.email);

      state = state.copyWith(apiState: ApiState.idle);
    } catch (e) {
      state = state.copyWith(apiState: ApiState.error);
      rethrow;
    }
  }

  void updateEmail(String value) {
    state = state.copyWith(email: value);
  }
}

class ForgotPasswordState {
  final ApiState apiStatus;
  final String email;

  ForgotPasswordState({
    this.apiStatus = ApiState.idle,
    this.email = '',
  });

  ForgotPasswordState copyWith({
    ApiState? apiState,
    String? email,
  }) {
    return ForgotPasswordState(
      apiStatus: apiState ?? apiStatus,
      email: email ?? this.email,
    );
  }
}
