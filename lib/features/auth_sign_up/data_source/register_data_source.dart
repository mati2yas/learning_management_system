import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterDataSource {
  final Dio _dio;

  RegisterDataSource(this._dio);

  Future<void> deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    var stringVal = prefs.getString("userData") ?? "{}";
    var mapVal = jsonDecode(stringVal);

    int? statusCode;
    var userId = mapVal["userId"] ?? "0";
    try {
      final response = await _dio.post("delete-user/$userId");
      statusCode = response.statusCode;
      if (response.statusCode == 200 && response.data['status'] == true) {
        await prefs.remove("userData");
        return;
        // Save the JSON string
      } else {
        throw Exception('Failed to delete user: ${response.data['message']}');
      }
    } on DioException catch (e) {
      String errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
  }

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

        final user = response.data['data']['user'];
        print("User Data to Save:");
        final prefs = await SharedPreferences.getInstance();
        var userId = user["id"] ?? "0";
        print("user id: $userId");
        final valueData = jsonEncode({
          "id": "\"$userId\"",
          "name": "\"$name\"",
          "email": "\"$email\"",
          "token": "",
          "password": "\"$password\"",
        });

        await prefs.setString("userData", valueData);
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
