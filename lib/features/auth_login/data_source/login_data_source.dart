import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginDataSource {
  final Dio _dio;

  LoginDataSource(this._dio);

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final token = response.data['token'];
        final user = response.data['data']['user'];
        var name = user["name"];

        final prefs = await SharedPreferences.getInstance();
        final valueData = jsonEncode({
          "name": "\"$name\"",
          "email": "\"$email\"",
          "token": "\"$token\"",
          "password": "\"$password\"",
        });

        await prefs.setString("userData", valueData);

        print("User Data to Save:");
        // print(valueData);

        // // Save the JSON string
      } else {
        throw Exception('Failed to register user');
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.response?.data['message'] ?? e.message}');
    }
  }
}
