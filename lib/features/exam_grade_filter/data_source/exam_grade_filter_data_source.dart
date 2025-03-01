import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/app_urls.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';

final examGradeFilterDataSourceProvider = Provider<ExamGradeFilterDataSource>(
    (ref) => ExamGradeFilterDataSource(DioClient.instance));

class ExamGradeFilterDataSource {
  final Dio _dio;
  ExamGradeFilterDataSource(this._dio);

  Future<List<ExamGrade>> fetchExamGrades({
    required int yearId,
    required int courseId,
  }) async {
    List<ExamGrade> examGrades = [];
    int? statusCode;
    try {
      final response =
          await _dio.get("${AppUrls.examGradeFilter}/$courseId/$yearId");
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
  }
}
