import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginDataSource {
  final Dio _dio;

  LoginDataSource(this._dio);

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    int? statusCode;
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });
      statusCode = response.statusCode;

      if (response.statusCode == 200) {
        if (response.data["is_verified"] == false) {
          throw Exception("Email not verified");
        }
        //final token = response.data['token'] ?? "";
        //final user = response.data['data']['user'] ?? "";
        //var name = user["name"];

        // TODO: fix the email thingy here. it shouldn't be email in the attribute of name
        final prefs = await SharedPreferences.getInstance();
        final valueData = jsonEncode({
          "name": "\"$email\"",
          "email": "\"$email\"",
          "token": "\"$password\"",
          "password": "\"$password\"",
        });

        await prefs.setString("userData", valueData);

        print("User Data to Save:");
        // print(valueData);

        // // Save the JSON string
      } else {
        throw Exception('Failed to login: Unknown error');
      }
    } on DioException catch (e) {
      String errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
  }
}
