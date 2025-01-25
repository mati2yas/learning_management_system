import 'package:lms_system/features/chapter_detail/model/chapter_detail_model.dart';

class Chapter {
  final String title, name, id;

  ChapterDetail? chapterDetail;
  List<Video> videos;
  Chapter({
    this.id = "",
    required this.name,
    required this.title,
    this.chapterDetail,
    this.videos = const [],
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    print("json:");
    print(json);
    return Chapter(
      id: json["id"].toString(),
      name: json["name"],
      title: json["name"],
    );
  }
}

class Video {
  final String url;
  final String duration;
  Video({
    required this.url,
    required this.duration,
  });
}
