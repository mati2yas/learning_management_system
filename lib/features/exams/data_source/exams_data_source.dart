import 'dart:math';

import 'package:lms_system/features/exams/model/exams_model.dart';

class ExamsDataSource {
  List<Exam> fetchExams() {
    return [
      Exam(
        title: "Mathematics Matric Exam",
        examType: ExamType.matric,
        course: ExamCourse(
          id: "1",
          title: "Mathematics",
          years: [
            ExamYear(title: "2012", grades: generateMatricGrades()),
            ExamYear(title: "2013", grades: generateMatricGrades()),
            ExamYear(title: "2014", grades: generateMatricGrades()),
          ],
        ),
      ),
      Exam(
        title: "English Matric Exam",
        examType: ExamType.matric,
        course: ExamCourse(
          id: "2",
          title: "English",
          years: [
            ExamYear(title: "2012", grades: generateMatricGrades()),
            ExamYear(title: "2013", grades: generateMatricGrades()),
            ExamYear(title: "2014", grades: generateMatricGrades()),
          ],
        ),
      ),
      // Add Chemistry and History similarly for matric

      // CoC Exams
      Exam(
        title: "Accounting CoC Exam",
        examType: ExamType.coc,
        course: ExamCourse(
          id: "3",
          title: "Accounting",
          years: [
            ExamYear(title: "2012", questions: generateQuestions(5)),
            ExamYear(title: "2013", questions: generateQuestions(5)),
            ExamYear(title: "2014", questions: generateQuestions(5)),
          ],
        ),
      ),
      Exam(
        title: "Nursing CoC Exam",
        examType: ExamType.coc,
        course: ExamCourse(
          id: "4",
          title: "Nursing",
          years: [
            ExamYear(title: "2012", questions: generateQuestions(5)),
            ExamYear(title: "2013", questions: generateQuestions(5)),
            ExamYear(title: "2014", questions: generateQuestions(5)),
          ],
        ),
      ),
      Exam(
        title: "IT CoC Exam",
        examType: ExamType.coc,
        course: ExamCourse(
          id: "5",
          title: "IT",
          years: [
            ExamYear(title: "2012", questions: generateQuestions(5)),
            ExamYear(title: "2013", questions: generateQuestions(5)),
            ExamYear(title: "2014", questions: generateQuestions(5)),
          ],
        ),
      ),
    ];
  }

  List<ExamChapter> generateChapters(int count) {
    return List.generate(count, (index) {
      return ExamChapter(
        id: index + 1,
        title: "Chapter ${index + 1}",
        questions: generateQuestions(5),
      );
    });
  }

  List<ExamGrade> generateMatricGrades() {
    return [
      ExamGrade(
        id: Random().nextInt(100).toString(),
        title: "Grade 9",
        chapters: generateChapters(3),
      ),
      ExamGrade(
        id: Random().nextInt(100).toString(),
        title: "Grade 10",
        chapters: generateChapters(3),
      ),
      ExamGrade(
        id: Random().nextInt(100).toString(),
        title: "Grade 11",
        chapters: generateChapters(3),
      ),
      ExamGrade(
        id: Random().nextInt(100).toString(),
        title: "Grade 12",
        chapters: generateChapters(3),
      ),
    ];
  }

  List<Question> generateQuestions(int count) {
    return List.generate(count, (index) {
      return Question(
        question: "Question ${index + 1}?",
        options: ["Option A", "Option B", "Option C", "Option D"],
        answer: "Option A",
        explanation: "Explanation for question ${index + 1}.",
      );
    });
  }
}
