import 'dart:convert';

import 'package:lms_system/features/shared/model/shared_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrentUserDataSource {
  Future<User> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    var userstr = prefs.getString("userData");
    print("userstr: $userstr");
    var userMap = jsonDecode(userstr ?? "") ?? {};

    String email = userMap["email"] ?? "";
    String password = userMap["password"] ?? "";
    email = email.replaceAll("\"", "");
    password = password.replaceAll("\"", "");
    final valueData = jsonEncode({
      "name": "\"dechasa\"",
      "email": "\"$email\"",
      "token": "\"$password\"",
      "password": "\"$password\"",
    });

    return User(
      name: userMap["name"] ?? "no name",
      email: userMap["email"] ?? "no password",
      password: "",
    );
  }
}
