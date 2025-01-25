import 'package:lms_system/features/shared/model/chapter.dart';

class ChapterContent {
  final List<Video> videos;
  final List<Document> documents;

  ChapterContent({
    required this.videos,
    required this.documents,
  });

  static ChapterContent fromJson(Map<String, dynamic> json) {
    List<Video> vids = [];
    List<Document> docs = [];
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
    return ChapterContent(videos: vids, documents: docs);
  }
}
