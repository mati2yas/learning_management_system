import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/features/edit_profile/repository/change_email_repository.dart';

final changeEmailControllerProvider =
    StateNotifierProvider<ChangeEmailController, ChangeEmailState>(
  (ref) => ChangeEmailController(ref.watch(changeEmailRepositoryProvider)),
);

class ChangeEmailController extends StateNotifier<ChangeEmailState> {
  final ChangeEmailRepository _repository;
  ChangeEmailController(this._repository) : super(ChangeEmailState());

  Future<ChangeEmailState> changeEmail() async {
    Response? response;

    state = state.copyWith(apiState: ApiState.busy);
    try {
      response = await _repository.changeEmail(email: state.email);

      if (response?.statusCode == 200) {
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
}

class ChangeEmailState {
  final ApiState apiStatus;
  final String email;
  final bool responseSuccess;

  ChangeEmailState({
    this.apiStatus = ApiState.idle,
    this.email = '',
    this.responseSuccess = false,
  });

  ChangeEmailState copyWith({
    ApiState? apiState,
    String? email,
    bool? responseSuccess,
  }) {
    return ChangeEmailState(
      apiStatus: apiState ?? apiStatus,
      email: email ?? this.email,
      responseSuccess: responseSuccess ?? this.responseSuccess,
    );
  }
}
