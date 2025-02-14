import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/db_service.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/features/shared/model/shared_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

final profileDataSourceProvider = Provider<ProfileDataSource>(
    (ref) => ProfileDataSource(DioClient.instance, DatabaseService()));

class ProfileDataSource {
  final Dio _dio;
  final DatabaseService _databaseService;

  ProfileDataSource(this._dio, this._databaseService);

  Future<User> fetchProfileFromBackend() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("userData") != null
          ? (await getToken()) // Retrieve token from SharedPreferences
          : null;

      if (token == null) throw Exception("No token found. Please log in.");

      final response = await _dio.get(
        "/user",
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

  Future<User?> fetchProfileFromDatabase() async {
    return await _databaseService.getUserFromDatabase();
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

  Future<void> saveProfileToDatabase(User user) async {
    await _databaseService.saveUserToDatabase(user);
  }

  Future<void> updateProfileInDatabase(User user) async {
    await _databaseService.updateUserInDatabase(user);
  }
}
