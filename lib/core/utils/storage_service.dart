import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';
import 'package:lms_system/features/shared/model/shared_user.dart';

import '../constants/app_strings.dart';

class SecureStorageService {
  static final SecureStorageService _instance =
      SecureStorageService._internal();
  final _storage = const FlutterSecureStorage();

  factory SecureStorageService() {
    return _instance;
  }
  SecureStorageService._internal();

  Future<void> deleteUser() async {
    await _storage.delete(key: AppStrings.userStorageKey);
  }

  Future<List<Course>> getCoursesFromLocal() async {
    final courseJson =
        await _storage.read(key: AppStrings.subbedCoursesStorageKey);
    if (courseJson != null) {
      final courseList = jsonDecode(courseJson) as List<dynamic>;
      return courseList.map((json) => Course.fromJsonLocal(json)).toList();
    }
    return [];
  }

  Future<bool> getOnboardingStatus() async {
    final status =
        await _storage.read(key: AppStrings.onboardingStatusStorageKey);
    return status == 'true';
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
    if (userJson != null) {
      final userMap = jsonDecode(userJson);
      return User.fromMap(userMap);
    }
    return null;
  }

  // Future<void> saveCoursesToLocal(List<Course> savedCourses) async {
  //   final savedCoursesJson =
  //       jsonEncode(savedCourses.map((course) => course.toJsonLocal()).toList());
  //   await _storage.write(
  //       key: AppStrings.subbedCoursesStorageKey, value: savedCoursesJson);
  // }

  Future<void> saveUserToStorage(User user) async {
    debugPrint("the user is: User{ name: ${user.name}, email: ${user.email}");
    debugPrint("password: ${user.password}}, token: ${user.token}");
    await _storage.write(
        key: AppStrings.userStorageKey, value: jsonEncode(user.toMap()));
    Future.delayed(Duration.zero);
  }

  Future<void> setOnboardingStatus(bool status) async {
    await _storage.write(
        key: AppStrings.onboardingStatusStorageKey, value: status.toString());
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
}
