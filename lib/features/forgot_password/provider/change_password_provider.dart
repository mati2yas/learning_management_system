import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/features/forgot_password/repository/forgot_password_repository.dart';

final changePasswordControllerProvider =
    StateNotifierProvider<ForgotPasswordController, ForgotPasswordState>(
  (ref) =>
      ForgotPasswordController(ref.watch(forgotPasswordRepositoryProvider)),
);

class ForgotPasswordController extends StateNotifier<ForgotPasswordState> {
  final ForgotPasswordRepository _repository;
  ForgotPasswordController(this._repository) : super(ForgotPasswordState());

  Future<ForgotPasswordState> changePassword() async {
    Response? response;

    state = state.copyWith(apiState: ApiState.busy);
    try {
      response = await _repository.changePassword(
          email: state.email, password: state.password, token: state.token);

      if (response.statusCode == 200) {
        state = state.copyWith(
          apiState: ApiState.idle,
          responseSuccess: true,
        );
      } else {
        state = state.copyWith(
          apiState: ApiState.error,
          responseSuccess: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        apiState: ApiState.error,
        responseSuccess: false,
      );
      rethrow;
    }
    return state;
  }

  void updateEmail(String value) {
    state = state.copyWith(email: value);
  }

  void updatePassword(String value) {
    state = state.copyWith(password: value);
  }

  void updateToken(String passChangeToken) {
    state = state.copyWith(token: passChangeToken);
  }
}

class ForgotPasswordState {
  final ApiState apiStatus;
  final String email;
  final String password;
  final String token;
  final bool responseSuccess;

  ForgotPasswordState({
    this.apiStatus = ApiState.idle,
    this.email = '',
    this.password = "",
    this.token = "",
    this.responseSuccess = false,
  });

  ForgotPasswordState copyWith({
    ApiState? apiState,
    String? email,
    String? password,
    String? token,
    bool? responseSuccess,
  }) {
    return ForgotPasswordState(
      apiStatus: apiState ?? apiStatus,
      email: email ?? this.email,
      password: password ?? this.password,
      token: token ?? this.token,
      responseSuccess: responseSuccess ?? this.responseSuccess,
    );
  }
}
