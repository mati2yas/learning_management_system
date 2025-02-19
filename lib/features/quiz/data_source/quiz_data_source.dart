import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/core/utils/util_functions.dart';

import '../model/quiz_model.dart';

final quizDataSourceProvider = Provider<QuizDataSource>((ref) {
  return QuizDataSource(DioClient.instance);
});

class QuizDataSource {
  final Dio _dio;
  QuizDataSource(this._dio);

  // Future<void> insertQuizScore(Quiz quiz, int score, int maxScore) async {
  //   final db = await database;
  // }

  Future<Quiz> fetchQuizData(String quizId) async {
    Quiz quiz = Quiz();
    int? statusCode;
    UtilFunctions.setToken();
    try {
      final response = await _dio.get("/quizzes/$quizId");
      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        quiz = Quiz.fromJson(response.data["data"]);
      }
    } on DioException catch (e) {
      String errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
    return quiz;
  }
}
