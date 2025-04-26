import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/features/shared/model/shared_user.dart';

import '../constants/app_strings.dart';

class SecureStorageService {
  static final SecureStorageService _instance =
      SecureStorageService._internal();
  late final FlutterSecureStorage _storage;
  factory SecureStorageService() {
    return _instance;
  }
  SecureStorageService._internal() {
    _storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
  }
  Future<void> deleteUser() async {
    await _storage.delete(key: AppStrings.userStorageKey);
  }

  // Future<List<Course>> getCoursesFromLocal() async {
  //   final courseJson =
  //       await _storage.read(key: AppStrings.subbedCoursesStorageKey);
  //   if (courseJson != null) {
  //     final courseList = jsonDecode(courseJson) as List<dynamic>;
  //     return courseList.map((json) => Course.fromJsonLocal(json)).toList();
  //   }
  //   return [];
  // }

  Future<bool> getOnboardingStatus() async {
    final status =
        await _storage.read(key: AppStrings.onboardingStatusStorageKey);
    return status == 'true';
  }

  Future<String?> getTokenFromStorage() async {
    final userToken = await _storage.read(key: AppStrings.apiTokenKey);
    return userToken;
  }

  Future<AuthStatus> getUserAuthedStatus() async {
    final authStat = await _storage.read(key: AppStrings.authStatusKey);
    return switch (authStat ?? "notAuthed") {
      "authed" => AuthStatus.authed,
      "notAuthed" => AuthStatus.notAuthed,
      "pending" => AuthStatus.pending,
      _ => AuthStatus.notAuthed,
    };
  }

  Future<User?> getUserFromStorage() async {
    final userJson = await _storage.read(key: AppStrings.userStorageKey);
    User? usr;
    if (userJson != null) {
      final userMap = jsonDecode(userJson);

      usr = User.fromMap(userMap);
      debugPrint(
          "user from storage: User(name: ${usr.name}, email: ${usr.email}, password: ${usr.password}, token: ${usr.token})");
    }
    return usr;
  }

  Future<void> saveUserToStorage(User user) async {
    debugPrint("the user is: User{ name: ${user.name}, email: ${user.email}");
    debugPrint("password: ${user.password}, token: ${user.token}}");
    await _storage.write(
        key: AppStrings.userStorageKey, value: jsonEncode(user.toMap()));
    Future.delayed(Duration.zero);
  }

  Future<void> setOnboardingStatus(bool status) async {
    await _storage.write(
        key: AppStrings.onboardingStatusStorageKey, value: status.toString());
  }

  Future<void> setTokenToStorage({required String token}) async {
    await _storage.write(key: AppStrings.apiTokenKey, value: token);
  }

  Future<void> setUserAuthedStatus(AuthStatus status) async {
    await _storage.write(key: AppStrings.authStatusKey, value: status.name);
  }

  Future<void> updateUserBioAndPfp(
      User user, String bio, String imagePath) async {
    final updatedUser = user.copyWith(bio: bio, image: imagePath);
    await saveUserToStorage(updatedUser);
  }

  Future<void> updateUserInStorage(User user) async {
    await saveUserToStorage(user);
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
}
