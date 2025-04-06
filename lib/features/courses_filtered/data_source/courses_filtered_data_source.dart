import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
      debugPrint("${AppUrls.baseUrl}/${AppUrls.getCourses}/$filter");
      final response = await _dio.get("${AppUrls.getCourses}/$filter");
      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        for (var dataEntry in response.data["data"]) {
          dataEntry["category"] = {"name": filter};
          Course crs = Course.fromJson(dataEntry);

          //debugPrint("in coures datasource: course stream: ${crs.stream}");
          courses.add(crs);
        }
        // TODO: check this one ordering
        courses.sort((a, b) => a.title.compareTo(b.title));
      }
    } on DioException catch (e) {
      String errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
    return courses;
  }
}
