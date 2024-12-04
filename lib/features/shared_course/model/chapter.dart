class Chapter {
  final String title, name;

  final List<Video> videos;
  Chapter({
    required this.name,
    required this.title,
    required this.videos,
  });
}

class Video {
  final String title;
  final String duration;
  Video({
    required this.title,
    required this.duration,
  });
}
