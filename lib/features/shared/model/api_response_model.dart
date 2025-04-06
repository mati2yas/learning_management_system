class ApiResponse {
  final String message;
  final bool responseStatus;
  dynamic data;
  ApiResponse({
    required this.message,
    required this.responseStatus,
    this.data,
  });
  ApiResponse copyWith({
    String? message,
    bool? status,
    dynamic data,
  }) {
    return ApiResponse(
      message: message ?? this.message,
      responseStatus: status ?? responseStatus,
      data: data ?? this.data,
    );
  }
}
