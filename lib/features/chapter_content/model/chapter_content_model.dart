import 'package:lms_system/features/shared/model/chapter.dart';

class ChapterContent {
  final List<Video> videos;
  final List<Document> documents;
  final List<Quiz> quizzes;

  ChapterContent({
    required this.videos,
    required this.documents,
    required this.quizzes,
  });

  static ChapterContent fromJson(Map<String, dynamic> json) {
    List<Video> vids = [];
    List<Document> docs = [];
    List<Quiz> quis = [];
    for (var vid in json["videos"]) {
      vids.add(
        Video(
          url: vid["url"],
          title: vid["title"],
        ),
      );
    }
    for (var doc in json["documents"]) {
      docs.add(
        Document(
          fileUrl: doc["file_url"],
          title: doc["title"],
        ),
      );
    }

    for (var quiz in json["quizzes"]) {
      quis.add(
        Quiz(id: quiz["id"].toString(), title: quiz['title']),
      );
    }
    return ChapterContent(
      videos: vids,
      documents: docs,
      quizzes: quis,
    );
  }
}
