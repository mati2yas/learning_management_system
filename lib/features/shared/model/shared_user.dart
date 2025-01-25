class User {
  final String name, lastName, email, password, bio, image;

  User({
    required this.name,
    required this.lastName,
    required this.email,
    required this.password,
    this.bio = "",
    this.image = "",
  });
}
