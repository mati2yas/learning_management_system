import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class EditProfileState {
  String name;
  String email;
  String password;
  String bio;
  String image;

  EditProfileState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.bio = '',
    this.image = '',
  });
  EditProfileState copyWith({
    String? name,
    String? email,
    String? password,
    String? bio,
    String? image,
  }) {
    return EditProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      bio: bio ?? this.bio,
      image: image ?? this.image,
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
