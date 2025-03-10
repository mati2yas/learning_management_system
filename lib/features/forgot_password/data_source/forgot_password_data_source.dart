import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/app_urls.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/core/utils/error_handling.dart';

final forgotPasswordDataSourceProvider =
    Provider<ForgotPasswordDataSource>((ref) {
  return ForgotPasswordDataSource(DioClient.instance);
});

class ForgotPasswordDataSource {
  final Dio _dio;

  ForgotPasswordDataSource(this._dio);

  Future<void> resetPassword() async {
    int? statusCode;
    try {
      final response = await _dio.post(AppUrls.forgotPassword);
      statusCode = response.statusCode;

      if (response.statusCode == 200) {
      } else if (response.statusCode == 403) {
        var msg = response.data["message"];
        throw Exception(msg);
      } else {
        throw Exception('Failed to reset password: Unknown error');
      }
    } on DioException catch (e) {
      String errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
  }
}
