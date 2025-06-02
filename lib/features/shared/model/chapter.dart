import 'package:lms_system/features/chapter_content/model/chapter_content_model.dart';
//import 'package:lms_system/features/exams/model/exams_model.dart';

class Chapter {
  final String title, name, id;
  final int order;
  ChapterContent? chapterDetail;
  List<Video> videos;
  Chapter({
    this.id = "",
    required this.order,
    required this.name,
    required this.title,
    this.chapterDetail,
    this.videos = const [],
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    //// print("json:");
    // print(json);
    //debugPrint("chapter id: ${json["id"] ?? 0}");
    return Chapter(
      id: json["id"].toString(),
      order: json["order"] ?? 0,
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

// class Quiz {
//   final String id;
//   final String title;
//   final int numOfQuestions;
//   List<Question> questions;

//   Quiz({
//     required this.id,
//     required this.title,
//     this.questions = const [],
//     required this.numOfQuestions,
//   });

//   factory Quiz.fromJson(Map<String, dynamic> json) {
//     return Quiz();
//   }
// }

// class Question {

// }
class Video {
  final String url;
  final String title;
  Video({
    required this.url,
    required this.title,
  });
}
