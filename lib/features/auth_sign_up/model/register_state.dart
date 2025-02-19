import 'package:lms_system/features/edit_profile/model/edit_profile_state.dart';

class RegisterState {
  final String name;
  final String email;
  final String password;
  final ApiState apiStatus;

  RegisterState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.apiStatus = ApiState.idle,
  });

  RegisterState copyWith({
    String? name,
    String? username,
    String? email,
    String? password,
    ApiState? apiState,
  }) {
    return RegisterState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      apiStatus: apiState ?? apiStatus,
    );
  }
}
