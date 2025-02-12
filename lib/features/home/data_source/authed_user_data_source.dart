import 'dart:convert';

import 'package:lms_system/features/shared/model/shared_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthedUserDataSource {
  AuthedUserDataSource();

  Future<User> fetchUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataJson = prefs.getString("userData") ?? "{}";
    final userData = jsonDecode(userDataJson);
    return User(
      name: userData["name"],
      lastName: userData["name"],
      email: userData["email"],
      password: userData["password"],
    );
  }
}
