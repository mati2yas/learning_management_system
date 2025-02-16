import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:lms_system/core/utils/db_service.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/core/utils/storage_service.dart';
import 'package:lms_system/features/shared/model/shared_user.dart';
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
      final response = await _dio.post('/student-register', data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
      });
      statusCode = response.statusCode;
      if (response.statusCode == 200 && response.data['status'] == true) {
        // Parse and store the token and user data in SharedPreferences

        final userJson = response.data['data']['user'];
        final user = User(
          id: userJson["id"],
          name: name,
          email: email,
          password: password,
          token: userJson["token"],
        );

        await _storageService.saveUserToStorage(user);

        // Save the JSON string
      } else if (response.statusCode == 403) {
        var msg = response.data["message"];
        throw Exception(msg);
      } else {
        throw Exception('Failed to register user: ${response.data['message']}');
      }
    } on DioException catch (e) {
      String errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
  }
}
