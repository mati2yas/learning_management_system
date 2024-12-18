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
  final String id;
  final String title;
  final List<ExamChapter> chapters;

  ExamGrade({
    required this.id,
    required this.title,
    required this.chapters,
  });
}

enum ExamType { matric, coc, ngat, exitexam }

class ExamYear {
  final String title;
  final List<Question> questions; // For non-matric exams
  final List<ExamGrade>? grades; // For matric exams

  ExamYear({
    required this.title,
    this.grades,
    this.questions = const [],
  });
}

class Question {
  final String question;
  final List<String> options;
  final String answer;
  final String explanation;
  String? image;

  Question({
    required this.question,
    required this.options,
    required this.answer,
    required this.explanation,
    this.image,
  });
}
