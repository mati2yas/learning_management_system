import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lms_system/core/api_constants.dart';
import 'package:lms_system/core/utils/storage_service.dart';

class DioClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 90),
      receiveTimeout: const Duration(seconds: 90),
      sendTimeout: const Duration(seconds: 90),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  static Dio get instance => _dio;

  static Future<void> setToken() async {
    final user = await SecureStorageService().getUserFromStorage();
    var token = user?.token;
    debugPrint("token: $token");
    if (token != null && token.isNotEmpty) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      debugPrint("header: ${_dio.options.headers["Authorization"]}");
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }
}
