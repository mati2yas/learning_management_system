import 'package:lms_system/features/shared/model/chapter.dart';

import '../../quiz/model/quiz_model.dart';

class ChapterContent {
  final List<Video> videos;
  final List<Document> documents;
  final List<Quiz> quizzes;
  final int order;

  ChapterContent({
    required this.videos,
    required this.documents,
    required this.quizzes,
    required this.order,
  });

  static ChapterContent fromJson(Map<String, dynamic> json) {
    List<Video> vids = [];
    List<Document> docs = [];
    List<Quiz> quizs = [];
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
      quizs.add(
        Quiz(
          id: quiz["id"],
          duration: quiz["quiz_duration"] ?? 0,
          title: quiz['title'],
          numberOfQuestions: quiz['number_of_questions'],
          questions: [],
        ),
      );
    }
    return ChapterContent(
      order: json["order"] ?? -1,
      videos: vids,
      documents: docs,
      quizzes: quizs,
    );
  }
}
