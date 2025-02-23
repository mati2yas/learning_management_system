import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';

final examFilterDataSourceProvider = Provider<ExamYearFilterDataSource>(
    (ref) => ExamYearFilterDataSource(DioClient.instance));

class ExamYearFilterDataSource {
  final Dio _dio;

  ExamYearFilterDataSource(this._dio);
  Future<List<ExamCourse>> fetchExamYears(ExamType type) async {
    //await Future.delayed(const Duration(seconds: 3));
    //_dio.options.headers["Content-Type"] = "application/json";
    int? statusCode;
    List<ExamCourse> examCourses = [];
    try {
      String examTypeString = getExamStringValue(type);
      final response = await _dio.get("/exams/exam-courses/$examTypeString");
      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        var data = response.data["data"];
        for (var d in data) {
          var exam = ExamCourse.fromJson(d);
          examCourses.add(exam);
        }
      }
    } on DioException catch (e) {
      final errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
    return examCourses;
  }

  String getExamStringValue(ExamType type) {
    return switch (type) {
      ExamType.matric => "ESSLCE",
      ExamType.ministry6th => "6th Grade Ministry",
      ExamType.ministry8th => "8th Grade Ministry",
      ExamType.exitexam => "EXIT",
      ExamType.uat => "UAT",
      ExamType.sat => "SAT",
      ExamType.ngat => "NGAT",
      _ => "ESSLCE"
    };
  }
}
