import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';

final examQuestionsDataSourceProvider = Provider<ExamQuestionsDataSource>(
    (ref) => ExamQuestionsDataSource(DioClient.instance));

class DioCient {}

class ExamQuestionsDataSource {
  final Dio _dio;

  ExamQuestionsDataSource(this._dio);

  Future<List<Question>> fetchQuestionsByChapterId(int chapterId) async {
    int? statusCode;
    List<Question> questions = [];
    try {
      final response =
          await _dio.get("/exams/exam-questions-chapter/$chapterId");

      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        var data = response.data["data"];
        for (var d in data) {
          var question = Question.fromJson(d);
          questions.add(question);
        }
      }
    } on DioException catch (e) {
      final errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
    return questions;
  }

  Future<List<Question>> fetchQuestiosnByYearId(int yearId) async {
    int? statusCode;
    List<Question> questions = [];
    try {
      final response = await _dio.get("/exams/exam-years/$yearId");
      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        var data = response.data["data"];
        for (var d in data) {
          var question = Question.fromJson(d);
          questions.add(question);
        }
      }
    } on DioException catch (e) {
      final errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
    return questions;
  }
}
