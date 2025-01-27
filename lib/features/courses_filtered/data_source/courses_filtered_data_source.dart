import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lms_system/core/api_constants.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';

class CoursesFilteredDataSource {
  final Dio _dio;
  CoursesFilteredDataSource(this._dio);

  Future<List<Course>> fetchCoursesFiltered(String filter) async {
    List<Course> courses = [];
    int? statusCode;
    try {
      debugPrint("${ApiConstants.baseUrl}/random-courses/$filter");
      final response = await _dio.get("/random-courses/$filter");
      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        for (var x in response.data["data"]) {
          x["category"] = {"name": filter};
          courses.add(Course.fromJson(x));
        }
      }
    } on DioException catch (e) {
      String errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
    return courses;
  }
}
