import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:shared_preferences/shared_preferences.dart';

final loginDataSourceProvider = Provider<LoginDataSource>((ref) {
  return LoginDataSource(DioClient.instance);
});

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
        Map<String, dynamic> userData = jsonDecode(
          prefs.getString("userData") ?? "{\"data\": \"no data\"}",
        );
        var name = userData["name"];
        var id = userData["id"];
        if (name != null) {
          name = name.replaceAll("\"", "");
        } else {
          name = "user-name";
        }
        var token = response.data["token"];
        final valueData = jsonEncode({
          "id": id ?? -1,
          "name": "\"$name\"",
          "email": "\"$email\"",
          "token": "\"$token\"",
          "password": "\"$password\"",
        });

        await prefs.setString("userData", valueData);

        debugPrint("User Data to Save:");
        debugPrint(valueData);

        // // Save the JSON string
      } else if (response.statusCode == 403) {
        var msg = response.data["message"];
        throw Exception(msg);
      } else {
        throw Exception('Failed to login: Unknown error');
      }
    } on DioException catch (e) {
      String errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
  }
}
