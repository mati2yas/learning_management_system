class Course {
  final String title, desc, image;
  final int topics, saves;
  final double progress;
  Course({
    required this.title,
    required this.desc,
    required this.topics,
    required this.saves,
    required this.image,
    this.progress = 0.0,
  });
}
