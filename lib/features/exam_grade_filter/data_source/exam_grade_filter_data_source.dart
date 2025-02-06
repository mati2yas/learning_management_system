import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/features/exams/data_source/exams_data_source.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';

final examGradeFilterDataSourceProvider = Provider<ExamGradeFilterDataSource>(
    (ref) => ExamGradeFilterDataSource(DioClient.instance));

class ExamGradeFilterDataSource {
  final Dio _dio;
  ExamGradeFilterDataSource(this._dio);

  Future<List<ExamGrade>> fetchExamGrades(int input) async {
    await Future.delayed(const Duration(seconds: 3));
    _dio.options.headers["Content-Type"] = "application/json";
    return [
      ExamGrade(
        id: "10",
        title: "Grade 10",
        chapters: [
          ExamChapter(
            id: 1,
            title: "Relations And Functions",
            questions: mathChapterOneGrade10,
          ),
          ExamChapter(
            id: 2,
            title: "Polynomial Functions",
            questions: mathChapterTwoGrade10,
          ),
        ],
      ),
      ExamGrade(
        id: "11",
        title: "Grade 11",
        chapters: [
          ExamChapter(
            id: 1,
            title: "Relations And Functions",
            questions: mathChapterOneGrade10,
          ),
          ExamChapter(
            id: 2,
            title: "Polynomial Functions",
            questions: mathChapterTwoGrade10,
          ),
        ],
      ),
      ExamGrade(
        id: "12",
        title: "Grade 12",
        chapters: [
          ExamChapter(
            id: 1,
            title: "Relations And Functions",
            questions: mathChapterOneGrade10,
          ),
          ExamChapter(
            id: 2,
            title: "Polynomial Functions",
            questions: mathChapterTwoGrade10,
          ),
        ],
      ),
      ExamGrade(
        id: "10",
        title: "Grade 10",
        chapters: [
          ExamChapter(
            id: 1,
            title: "Relations And Functions",
            questions: mathChapterOneGrade10,
          ),
          ExamChapter(
            id: 2,
            title: "Polynomial Functions",
            questions: mathChapterTwoGrade10,
          ),
        ],
      ),
      ExamGrade(
        id: "11",
        title: "Grade 11",
        chapters: [
          ExamChapter(
            id: 1,
            title: "Relations And Functions",
            questions: mathChapterOneGrade10,
          ),
          ExamChapter(
            id: 2,
            title: "Polynomial Functions",
            questions: mathChapterTwoGrade10,
          ),
        ],
      ),
      ExamGrade(
        id: "12",
        title: "Grade 12",
        chapters: [
          ExamChapter(
            id: 1,
            title: "Relations And Functions",
            questions: mathChapterOneGrade10,
          ),
          ExamChapter(
            id: 2,
            title: "Polynomial Functions",
            questions: mathChapterTwoGrade10,
          ),
        ],
      ),
    ];
  }
}
