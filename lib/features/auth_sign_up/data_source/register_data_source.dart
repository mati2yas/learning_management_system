import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/core/utils/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterDataSource {
  final Dio _dio;
  final SecureStorageService _storageService;

  RegisterDataSource(this._dio, this._storageService);

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
      final response = await _dio.post(
        '/student-register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password,
        },
        options: Options(headers: {"Content-Type": "application/json"}),
      );
      debugPrint("register status code: ${response.statusCode}");
      debugPrint("register response data: ${response.data}");
      statusCode = response.statusCode;
      if ([200, 201].contains(response.statusCode)) {
        // Parse and store the token and user data in SharedPreferences

        // Save the JSON string
      } else if (response.statusCode == 403) {
        var msg = response.data["message"];
        throw Exception(msg);
      } else {
        throw Exception('Failed to register user: ${response.data['message']}');
      }
    } on DioException catch (e) {
      String errorMessage = "Registration Failed.";
      errorMessage = ApiExceptions.getExceptionMessage(
          e, statusCode ?? e.response?.statusCode);

      throw Exception(errorMessage);
    }
  }
}
