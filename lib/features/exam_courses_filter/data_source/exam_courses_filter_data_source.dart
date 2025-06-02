import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/app_strings.dart';
import 'package:lms_system/core/constants/app_urls.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';

final examFilterDataSourceProvider = Provider<ExamCoursesFilterDataSource>(
    (ref) => ExamCoursesFilterDataSource(DioClient.instance));

class ExamCoursesFilterDataSource {
  final Dio _dio;

  ExamCoursesFilterDataSource(this._dio);
  Future<List<ExamCourse>> fetchExamCourses(ExamType type) async {
    int? statusCode;
    List<ExamCourse> examCourses = [];
    try {
      String examTypeString = getExamStringValue(type);
      final response = await _dio.get("${AppUrls.examCourses}/$examTypeString");
      //debugPrint("url: ${AppUrls.examCourses}/$examTypeString");
      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        var data = response.data["data"];

        for (var d in data) {
          var exam = ExamCourse.fromJson(d);
          examCourses.add(exam);
        }

        examCourses.sort(
            (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        for (var course in examCourses) {
          course.years.sort(
              (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        }

        //debugPrint("in exam-course-fetcheer datasource");
        for (var exCourse in examCourses) {
          debugPrint(
              "exam sheet ids for course of id ${exCourse.id} and name of ${exCourse.title}: [${exCourse.years.map((yr) => yr.examSheetId).toList().join(",")}] ");
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
      ExamType.matric => AppStrings.matric,
      ExamType.ministry6th => AppStrings.ministry6th,
      ExamType.ministry8th => AppStrings.ministry8th,
      ExamType.exitexam => AppStrings.exit,
      ExamType.uat => AppStrings.uat,
      ExamType.sat => AppStrings.sat,
      ExamType.ngat => AppStrings.ngat,
      ExamType.exam => AppStrings.exam,
    };
  }
}
