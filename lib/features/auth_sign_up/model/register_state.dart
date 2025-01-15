class RegisterState {
  final String name;
  final String email;
  final String password;

  RegisterState({
    this.name = '',
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
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}