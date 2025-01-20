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
  final String url;
  final String duration;
  Video({
    required this.url,
    required this.duration,
  });
}
