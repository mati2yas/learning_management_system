import 'package:dio/dio.dart';

enum ApiState { busy, error, idle }

class User {
  final String name, email, password, bio, image, token;

  User({
    required this.name,
    required this.email,
    required this.password,
    this.bio = "",
    this.image = "",
    this.token = "",
  });

  User copyWith({
    String? name,
    String? email,
    String? password,
    String? bio,
    String? image,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      bio: bio ?? this.bio,
      image: image ?? this.image,
    );
  }

  Future<FormData> toFormData() async {
    FormData formData = FormData();
    formData.fields.add(MapEntry("name", name));
    formData.fields.add(MapEntry("email", email));
    formData.fields.add(MapEntry("password", password));
    formData.fields.add(MapEntry("bio", bio));
    formData.files.add(
      MapEntry(
        "avatar",
        await MultipartFile.fromFile(image),
      ),
    );
    return formData;
  }

  Map<String, dynamic> toJson() {
    return {
      "name": "\"$name\"",
      "email": "\"$email\"",
      "token": "\"$token\"",
      "password": "\"$password\"",
    };
  }

  static User initial() {
    return User(name: "", email: "", password: "");
  }
}

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
