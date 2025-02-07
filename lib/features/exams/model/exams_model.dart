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
  final String id;
  final String title;
  final List<ExamYear> years;

  ExamCourse({
    required this.id,
    required this.title,
    required this.years,
  });
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
      chapters: chaps ,
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
    return ExamYear(
      id: json['id'] ?? 0,
      title: json["exam_year"],
      courseId: json["course_id"] ?? 0,
      questionCount: json['question_count'],
    );
  }
}

class Question {
  final String question;
  final List<String> options;
  final String answer;
  final String explanation;
  final int sequenceOrder;
  String? image;

  var imageExplanationUrl;

  Question({
    required this.question,
    required this.options,
    required this.answer,
    required this.explanation,
    required this.sequenceOrder,
    this.image,
  });
}
