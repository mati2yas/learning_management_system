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

  Future<void> resetPassword() async {
    state = state.copyWith(apiState: ApiState.busy);
    try {
      await _repository.resetPassword();

      state = state.copyWith(apiState: ApiState.idle);
    } catch (e) {
      state = state.copyWith(apiState: ApiState.error);
      rethrow;
    }
  }
}

class ForgotPasswordState {
  final ApiState apiStatus;

  ForgotPasswordState({
    this.apiStatus = ApiState.idle,
  });

  ForgotPasswordState copyWith({
    ApiState? apiState,
  }) {
    return ForgotPasswordState(
      apiStatus: apiState ?? apiStatus,
    );
  }
}
