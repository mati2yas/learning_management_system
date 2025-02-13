import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/core/utils/shared_pref/shared_pref.dart';
import 'package:lms_system/features/shared/model/shared_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

final profileDataSourceProvider =
    Provider<ProfileDataSource>((ref) => ProfileDataSource(DioClient.instance));

class ProfileDataSource {
  final Dio _dio;
  ProfileDataSource(this._dio);

  Future<Response> editProfile(
    User user,
  ) async {
    int? statusCode;
    FormData formData = await user.toFormData();
    var token = await SharedPrefService.getUserToken();
    DioClient.setToken(token);
    try {
      _dio.options.headers['Content-Type'] = 'multipart/form-data';
      final response = await _dio.post(
        "/user-update",
        data: formData,
      );
      statusCode = response.statusCode;
      return response;
    } on DioException catch (e) {
      String errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
  }

  Future<User> fetchProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("userData") != null
          ? (await getToken()) // Retrieve token from SharedPreferences
          : null;

      if (token == null) throw Exception("No token found. Please log in.");

      final response = await _dio.get(
        "https://your-api.com/profile",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return User(
          name: data["name"],
          email: data["email"],
          bio: data["bio"] ?? "No bio available",
          password: "",
          image: data["avatar"] ?? "assets/images/profile_pic.png",
        );
      } else {
        throw Exception("Failed to load profile");
      }
    } catch (e) {
      throw Exception("Error fetching profile: $e");
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString("userData");
    if (userData != null) {
      final decodedData = jsonDecode(userData);
      return decodedData["token"];
    }
    return null;
  }
}
