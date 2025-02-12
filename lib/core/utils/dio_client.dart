import 'package:dio/dio.dart';
import 'package:lms_system/core/api_constants.dart';

class DioClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30), // 5 seconds
      receiveTimeout: const Duration(seconds: 30), // 3 seconds

      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  static Dio get instance => _dio;

  static void setToken(String? token) {
    _dio.options.headers['Authorization'] =
        token != null ? 'Bearer $token' : null;
  }
}
