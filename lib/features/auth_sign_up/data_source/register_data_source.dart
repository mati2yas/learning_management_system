import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterDataSource {
  final Dio _dio;

  RegisterDataSource(this._dio);

  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post('/student-register', data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
      });

      if (response.statusCode == 200 && response.data['status'] == true) {
        // Parse and store the token and user data in SharedPreferences
        final token = response.data['token'];
        final user = response.data['data']['user'];

        final prefs = await SharedPreferences.getInstance();
        final valueData = jsonEncode({
          "name": "\"$name\"",
          "email": "\"$email\"",
          "token": "\"$token\"",
          "password": "\"$password\"",
        });
        await prefs.setString("userData", valueData);

        print("User Data to Save:");
        print(valueData);

        // Save the JSON string
      } else {
        throw Exception('Failed to register user: ${response.data['message']}');
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.response?.data['message'] ?? e.message}');
    }
  }
}
