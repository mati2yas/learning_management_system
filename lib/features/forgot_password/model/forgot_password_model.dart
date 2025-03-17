class ForgotPasswordModel {
  final String email, token;
  ForgotPasswordModel({
    required this.email,
    required this.token,
  });
  ForgotPasswordModel.fromMap(Map<String, dynamic> map)
      : email = map['email'] as String,
        token = map['token'] as String;
  Map<String, dynamic> toJson() {
    return {
      "email": "\"$email\"",
      "token": "\"$token\"",
    };
  }

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "token": token,
    };
  }
}
