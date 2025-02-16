import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lms_system/features/shared/model/shared_user.dart';

class SecureStorageService {
  static final SecureStorageService _instance =
      SecureStorageService._internal();
  final _storage = const FlutterSecureStorage();

  factory SecureStorageService() {
    return _instance;
  }

  SecureStorageService._internal();

  Future<void> deleteUser() async {
    await _storage.delete(key: 'user');
  }

  Future<User?> getUserFromStorage() async {
    final userJson = await _storage.read(key: 'user');
    if (userJson != null) {
      final userMap = jsonDecode(userJson);
      return User.fromMap(userMap);
    }
    return null;
  }

  Future<void> saveUserToStorage(User user) async {
    await _storage.write(key: 'user', value: jsonEncode(user.toMap()));
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
