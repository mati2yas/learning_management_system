import 'package:lms_system/features/chapter_content/model/chapter_content_model.dart';

class Chapter {
  final String title, name, id;

  ChapterContent? chapterDetail;
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

class Document {
  final String fileUrl;
  final String title;
  Document({
    required this.fileUrl,
    required this.title,
  });
}

class Video {
  final String url;
  final String title;
  Video({
    required this.url,
    required this.title,
  });
}
