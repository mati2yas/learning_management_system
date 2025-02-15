import 'package:dio/dio.dart';

class User {
  final String name, email, password;
  String bio, image, token;
  final int id;

  User({
    this.id = -1,
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
    formData.fields.add(MapEntry("bio", bio));
    formData.fields.add(MapEntry("email", email));

    final fileExt = image.split(".").last;
    final fileName = 'avatar.$fileExt';
    final file = await MultipartFile.fromFile(
      image,
      filename: fileName,
    );
    formData.files.add(MapEntry('avatar', file));

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

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "password": password,
      "token": token,
      "bio": bio,
      "image": image,
    };
  }

  @override
  String toString() {
    return "User{name: $name, email: $email, token: $token, bio: $bio}";
  }

  static User initial() {
    return User(name: "", email: "", password: "");
  }
}
