import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/core/utils/error_handling.dart';

import '../../shared/model/shared_course_model.dart';

final courseDataSourceProvider =
    Provider<CourseDataSource>((ref) => CourseDataSource(DioClient.instance));

class CourseDataSource {
  final Dio _dio;
  CourseDataSource(this._dio);

  Future<List<Course>> fetchCourses() async {
    
    int? statusCode;

    List<Course> courses = [];
    try {
      final response = await _dio.get("/random-courses");
      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        print("response is 200");
        //var data = response.data["data"];
        //print(response.data["data"]);
        for (var x in response.data["data"]) {
          print(x.runtimeType);
          Course crs = Course.fromJson(x);
          courses.add(crs);
        }
      }
    } on DioException catch (e) {
      String errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
    return courses;
  }
}
