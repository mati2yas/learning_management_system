import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterDataSource {
  final Dio _dio;

  RegisterDataSource(this._dio);

  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    int? statusCode;
    try {
      final response = await _dio.post('/student-register', data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
      });
      statusCode = response.statusCode;
      if (response.statusCode == 200 && response.data['status'] == true) {
        // Parse and store the token and user data in SharedPreferences

        print("User Data to Save:");

        // Save the JSON string
      } else {
        throw Exception('Failed to register user: ${response.data['message']}');
      }
    } on DioException catch (e) {
      String errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
  }
}
