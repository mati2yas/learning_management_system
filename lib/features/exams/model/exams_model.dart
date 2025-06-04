import 'dart:convert';

import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/features/exams/model/exam_year.dart';

class Exam {
  final String title;
  final List<ExamCourse> courses;
  final ExamType examType;

  Exam({
    required this.title,
    required this.examType,
    required this.courses,
  });
}

class ExamChapter {
  final int id;
  final String title;
  final List<Question> questions;
  final int questionsCount;

  ExamChapter({
    required this.id,
    required this.title,
    required this.questions,
    required this.questionsCount,
  });
  factory ExamChapter.fromJson(Map<String, dynamic> json) {
    int qCount = 0;
    if (json["number_of_question"] is String) {
      qCount = int.tryParse(json["number_of_questions"]) ?? 0;
    } else if (json["number_of_questions"] is int) {
      qCount = json["number_of_questions"] ?? 0;
    }
    return ExamChapter(
      id: json["id"],
      title: json["title"],
      questions: [],
      questionsCount: qCount,
    );
  }
}

class ExamCourse {
  final int id;
  final String title;
  final List<ExamYear> years;

  ExamCourse({
    required this.id,
    required this.title,
    required this.years,
  });
  factory ExamCourse.fromJson(Map<String, dynamic> json) {
    List<ExamYear> years = [];
    for (var yr in json["exam_years"]) {
      yr["parent_course_title"] = json["course_name"] ??
          "Untitled Course"; // append course name to year
      years.add(ExamYear.fromJson(yr));
    }

    return ExamCourse(
      id: json["id"],
      title: json["course_name"] ?? "coursename",
      years: years,
    );
  }
}

class ExamGrade {
  final int id;
  final String title;
  final List<ExamChapter> chapters;

  ExamGrade({
    required this.id,
    required this.title,
    this.chapters = const [],
  });
  factory ExamGrade.fromJson(Map<String, dynamic> json) {
    var chapters = json["chapters"] as List<dynamic>;
    List<ExamChapter> chaps = [];
    if (chapters.isNotEmpty) {
      for (var chap in chapters) {
        chaps.add(
          ExamChapter(
            id: chap["id"],
            title: chap["title"],
            questionsCount: (chap["questions_count"] ?? 0),
            questions: [],
          ),
        );
      }
    }
    return ExamGrade(
      id: json["id"],
      title: "Grade ${json["grade"]}",
      chapters: chaps,
    );
  }
}

class Question {
  final String questionText;
  final List<String> options;
  final List<String> answers;
  final String explanation;
  final int sequenceOrder;
  final int id;
  String? imageUrl;
  String? imageExplanationUrl, videoExplanationUrl;

  Question({
    required this.id,
    required this.questionText,
    required this.options,
    required this.answers,
    required this.explanation,
    required this.sequenceOrder,
    this.imageUrl,
    this.imageExplanationUrl,
    this.videoExplanationUrl,
  });
  factory Question.fromJson(Map<String, dynamic> json) {
    List<dynamic> optionsJson = jsonDecode(json["options"]);
    List<String> optionsString =
        optionsJson.map((opt) => opt.toString()).toList();
    List<dynamic> answersJson = jsonDecode(json["answer"]);
    List<String> answersString =
        answersJson.map((ans) => ans.toString()).toList();
    //debugPrint("question img url: ${json["question_image_url"]}");

    return Question(
      id: json["id"],
      //sequenceOrder: json["sequence_order"],
      sequenceOrder: 0,
      questionText: json["question_text"],
      //options: json["options"] as List<String>,
      options: optionsString,
      answers: answersString,
      imageUrl: json["question_image_url"],
      imageExplanationUrl: json["image_explanation_url"],
      videoExplanationUrl: json["video_explanation_url"],
      explanation: json["text_explanation"] ?? "",
    );
  }
}
