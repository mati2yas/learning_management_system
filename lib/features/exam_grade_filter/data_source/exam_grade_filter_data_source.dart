import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';

final examGradeFilterDataSourceProvider = Provider<ExamGradeFilterDataSource>(
    (ref) => ExamGradeFilterDataSource(DioClient.instance));

class ExamGradeFilterDataSource {
  final Dio _dio;
  ExamGradeFilterDataSource(this._dio);

  Future<List<ExamGrade>> fetchExamGrades(int examYearId) async {
    //await Future.delayed(const Duration(seconds: 3));
    List<ExamGrade> examGrades = [];
    int? statusCode;
    try {
      final response = await _dio.get("/exams/exam-grades/$examYearId");
      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        var data = response.data["data"];
        for (var d in data) {
          examGrades.add(ExamGrade.fromJson(d));
        }
      }
    } on DioException catch (e) {
      final errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
    return examGrades;
    // return [
    //   ExamGrade(
    //     id: "10",
    //     title: "Grade 10",
    //     chapters: [
    //       ExamChapter(
    //         id: 1,
    //         title: "Relations And Functions",
    //         questions: mathChapterOneGrade10,
    //       ),
    //       ExamChapter(
    //         id: 2,
    //         title: "Polynomial Functions",
    //         questions: mathChapterTwoGrade10,
    //       ),
    //     ],
    //   ),
    //   ExamGrade(
    //     id: "11",
    //     title: "Grade 11",
    //     chapters: [
    //       ExamChapter(
    //         id: 1,
    //         title: "Relations And Functions",
    //         questions: mathChapterOneGrade10,
    //       ),
    //       ExamChapter(
    //         id: 2,
    //         title: "Polynomial Functions",
    //         questions: mathChapterTwoGrade10,
    //       ),
    //     ],
    //   ),
    //   ExamGrade(
    //     id: "12",
    //     title: "Grade 12",
    //     chapters: [
    //       ExamChapter(
    //         id: 1,
    //         title: "Relations And Functions",
    //         questions: mathChapterOneGrade10,
    //       ),
    //       ExamChapter(
    //         id: 2,
    //         title: "Polynomial Functions",
    //         questions: mathChapterTwoGrade10,
    //       ),
    //     ],
    //   ),
    //   ExamGrade(
    //     id: "10",
    //     title: "Grade 10",
    //     chapters: [
    //       ExamChapter(
    //         id: 1,
    //         title: "Relations And Functions",
    //         questions: mathChapterOneGrade10,
    //       ),
    //       ExamChapter(
    //         id: 2,
    //         title: "Polynomial Functions",
    //         questions: mathChapterTwoGrade10,
    //       ),
    //     ],
    //   ),
    //   ExamGrade(
    //     id: "11",
    //     title: "Grade 11",
    //     chapters: [
    //       ExamChapter(
    //         id: 1,
    //         title: "Relations And Functions",
    //         questions: mathChapterOneGrade10,
    //       ),
    //       ExamChapter(
    //         id: 2,
    //         title: "Polynomial Functions",
    //         questions: mathChapterTwoGrade10,
    //       ),
    //     ],
    //   ),
    //   ExamGrade(
    //     id: "12",
    //     title: "Grade 12",
    //     chapters: [
    //       ExamChapter(
    //         id: 1,
    //         title: "Relations And Functions",
    //         questions: mathChapterOneGrade10,
    //       ),
    //       ExamChapter(
    //         id: 2,
    //         title: "Polynomial Functions",
    //         questions: mathChapterTwoGrade10,
    //       ),
    //     ],
    //   ),
    // ];
  }
}
