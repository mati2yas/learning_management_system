class ForgotPasswordModel {
  final String email;
  final String apiSuccess, apiMessage;
  final String pinToken;
  ForgotPasswordModel({
    required this.email,
    this.pinToken = "",
    this.apiMessage = "",
    this.apiSuccess = "",
  });
}
