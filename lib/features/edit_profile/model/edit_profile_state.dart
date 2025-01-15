import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class EditProfileState {
  final String name;
  final String email;
  final String password;

  EditProfileState({
    this.name = '',
    this.email = '',
    this.password = '',
  });
  EditProfileState copywith({
    String? name,
    String? email,
    String? password,
  }) {
    return EditProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  static Future<EditProfileState> initial() async {
    final prefs = await SharedPreferences.getInstance();
    var stringVal = prefs.getString("userData") ?? "{}";
    var mapVal = jsonDecode(stringVal);
    return EditProfileState(
      name: mapVal["name"],
      email: mapVal["email"],
      password: mapVal["password"],
    );
  }
}
