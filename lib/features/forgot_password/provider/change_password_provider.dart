import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/utils/storage_service.dart';
import 'package:lms_system/features/forgot_password/repository/forgot_password_repository.dart';

final changePasswordControllerProvider =
    StateNotifierProvider<ForgotPasswordController, ForgotPasswordState>(
  (ref) =>
      ForgotPasswordController(ref.watch(forgotPasswordRepositoryProvider)),
);

class ForgotPasswordController extends StateNotifier<ForgotPasswordState> {
  final ForgotPasswordRepository _repository;
  ForgotPasswordController(this._repository) : super(ForgotPasswordState()) {
    loadEmailAndToken();
  }

  Future<void> changePassword() async {
    state = state.copyWith(apiState: ApiState.busy);
    try {
      await _repository.changePassword(
          email: state.email, password: state.password, token: state.token);

      state = state.copyWith(apiState: ApiState.idle);
    } catch (e) {
      state = state.copyWith(apiState: ApiState.error);
      rethrow;
    }
  }

  Future<void> loadEmailAndToken() async {
    final forgotpassData = await SecureStorageService().getForgotPassData();
    if (forgotpassData == null) {
      return;
    }

    String email = forgotpassData.email;
    String resetToken = forgotpassData.token;

    state = state.copyWith(email: email);
    state = state.copyWith(token: resetToken);
  }

  void updateEmail(String value) {
    state = state.copyWith(email: value);
  }

  void updatePassword(String value) {
    state = state.copyWith(password: value);
  }
}

class ForgotPasswordState {
  final ApiState apiStatus;
  final String email;
  final String password;
  final String token;

  ForgotPasswordState({
    this.apiStatus = ApiState.idle,
    this.email = '',
    this.password = "",
    this.token = "",
  });

  ForgotPasswordState copyWith({
    ApiState? apiState,
    String? email,
    String? password,
    String? token,
  }) {
    return ForgotPasswordState(
      apiStatus: apiState ?? apiStatus,
      email: email ?? this.email,
      password: password ?? this.password,
      token: token ?? this.token,
    );
  }
}
