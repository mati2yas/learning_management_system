import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/model/shared_user.dart';

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
enum ApiState { busy, error, idle }
class UserWrapper extends User {
  ApiState apiState;
  String statusMsg;
  UserWrapper({
    required super.name,
    required super.email,
    required super.password,
    super.bio = "",
    super.image = "",
    super.token = "",
    this.statusMsg = "",
    this.apiState = ApiState.idle,
  });
  @override
  UserWrapper copyWith({
    String? name,
    String? email,
    String? password,
    String? bio,
    String? image,
    String? token,
    String? statusMsg,
    ApiState? apiState,
  }) {
    return UserWrapper(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      bio: bio ?? this.bio,
      image: image ?? this.image,
      token: token ?? this.token,
      statusMsg: statusMsg ?? this.statusMsg,
      apiState: apiState ?? this.apiState,
    );
  }

  static UserWrapper initial() {
    return UserWrapper(
      name: "",
      email: "",
      password: "",
    );
  }
}
