import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/app_urls.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';

final coursesFilteredDataSourceProvider =
    Provider<CoursesFilteredDataSource>((ref) {
  return CoursesFilteredDataSource(DioClient.instance);
});

class CoursesFilteredDataSource {
  final Dio _dio;
  CoursesFilteredDataSource(this._dio);

  Future<List<Course>> fetchCoursesFiltered(String filter) async {
    List<Course> courses = [];
    int? statusCode;
    try {
      debugPrint("${AppUrls.baseUrl}/random-courses/$filter");
      final response = await _dio.get("${AppUrls.coursesFilter}/$filter");
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
