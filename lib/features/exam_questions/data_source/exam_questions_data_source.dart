import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/app_urls.dart';
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
    debugPrint("chapter id: $chapterId");
    try {
      final response =
          await _dio.get("${AppUrls.examChapterQuestions}/$chapterId");

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

  Future<List<Question>> fetchQuestionsByYearId(
      int yearId, int courseId) async {
    int? statusCode;
    List<Question> questions = [];
    debugPrint("year id: $yearId");
    try {
      final response =
          await _dio.get("${AppUrls.examYearQuestions}/$courseId/$yearId");
      debugPrint(
          "the of exam question fetch: ${AppUrls.examYearQuestions}/$courseId/$yearId");
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
