import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lms_system/core/constants/app_urls.dart';
import 'package:lms_system/core/utils/storage_service.dart';

class DioClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppUrls.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  static Dio get instance {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint("➡️ Request: ${options.method} ${options.uri}");
          debugPrint("🛜 Headers: ${options.headers}");
          debugPrint("🛜 Authorization: ${options.headers["Authorization"]}");
          debugPrint("🛜 Body: ${options.data}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint("✅ Response: ${response.statusCode}");
          debugPrint("✅ Response Time: ${response.extra["duration"]} ms");
          debugPrint("✅ Response data: ${response.data}");
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          debugPrint("❌ Error: ${e.response?.statusCode}");
          debugPrint("Message: ${e.response?.data}");
          return handler.next(e);
        },
      ),
    );
    return _dio;
  }

  static Future<void> setToken() async {
    //final user = await SecureStorageService().getUserFromStorage();
    //var token = user?.token;
    final token = await SecureStorageService().getTokenFromStorage();
    debugPrint("in set token: user token to be set: $token");
    if (token != null && token.isNotEmpty) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      debugPrint("header: ${_dio.options.headers["Authorization"]}");
    } else {
      debugPrint("diotoken being removed.");
      _dio.options.headers.remove('Authorization');
    }
  }
}
