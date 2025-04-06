import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/features/forgot_password/model/forgot_password_model.dart';

import '../repository/forgot_password_repository.dart';

final forgotPasswordControllerProvider =
    StateNotifierProvider<ForgotPasswordController, ForgotPasswordState>(
  (ref) =>
      ForgotPasswordController(ref.watch(forgotPasswordRepositoryProvider)),
);

class ForgotPasswordController extends StateNotifier<ForgotPasswordState> {
  final ForgotPasswordRepository _repository;
  ForgotPasswordController(this._repository) : super(ForgotPasswordState());

  Future<ForgotPasswordModel> forgotPassword() async {
    state = state.copyWith(apiState: ApiState.busy);
    ForgotPasswordModel forgotPassData =
        ForgotPasswordModel(email: "", pinToken: "");
    try {
      forgotPassData = await _repository.forgotPassword(email: state.email);

      state = state.copyWith(
        apiState: ApiState.idle,
        passwordChangeToken: forgotPassData.pinToken,
      );
    } catch (e) {
      state = state.copyWith(apiState: ApiState.error);
      rethrow;
    }
    return forgotPassData;
  }

  void updateEmail(String value) {
    state = state.copyWith(email: value);
  }
}

class ForgotPasswordState {
  final ApiState apiStatus;
  final String email;
  final String passwordChangeToken;

  ForgotPasswordState({
    this.apiStatus = ApiState.idle,
    this.email = '',
    this.passwordChangeToken = '',
  });

  ForgotPasswordState copyWith({
    ApiState? apiState,
    String? email,
    String? passwordChangeToken,
  }) {
    return ForgotPasswordState(
      apiStatus: apiState ?? apiStatus,
      email: email ?? this.email,
      passwordChangeToken: passwordChangeToken ?? this.passwordChangeToken,
    );
  }
}
