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

  ExamChapter({
    required this.id,
    required this.title,
    required this.questions,
  });
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

enum ExamType { matric, coc, ngat, exitexam, ministry }

class ExamYear {
  final String title;
  final int id, courseId, questionCount;
  final List<Question> questions; // For non-matric exams
  final List<ExamGrade> grades; // For matric exams

  ExamYear({
    required this.id,
    required this.courseId,
    required this.title,
    this.questions = const [],
    this.questionCount = 0,
    this.grades = const [],
  });

  factory ExamYear.fromJson(Map<String, dynamic> json) {
    int? id;
    if (json["id"] == "") {
      id = 0;
    } else {
      id = int.tryParse(json["id"]);
    }
    return ExamYear(
      id: id ?? 0,
      title: json["year_name"] ?? "year name",
      courseId: json["course_id"] ?? 0,
      questionCount: json['question_count'] ?? 0,
    );
  }
}

class Question {
  final String questionText;
  final List<String> options;
  final String answer;
  final String explanation;
  final int sequenceOrder;
  final int id;
  String? imageUrl;
  String? imageExplanationUrl, videoExplanationUrl;

  Question({
    required this.id,
    required this.questionText,
    required this.options,
    required this.answer,
    required this.explanation,
    required this.sequenceOrder,
    this.imageUrl,
    this.imageExplanationUrl,
    this.videoExplanationUrl,
  });
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json["id"],
      sequenceOrder: json["sequence_order"],
      questionText: json["question_text"],
      options: json["options"] as List<String>,
      answer: json["answer"],
      imageUrl: json["question_image_url"],
      imageExplanationUrl: json["image_explanation_url"],
      videoExplanationUrl: json["video_explanation_url"],
      explanation: json["text_explanation"],
    );
  }
}
