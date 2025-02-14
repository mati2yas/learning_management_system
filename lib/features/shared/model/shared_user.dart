import 'package:dio/dio.dart';

class User {
  final String name, email, password, bio, image, token;
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

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "token": token,
      "password": password,
      "image": image,
      "bio": bio,
    };
  }

  static User initial() {
    return User(name: "", email: "", password: "");
  }
}
