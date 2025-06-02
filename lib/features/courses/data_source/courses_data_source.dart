import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/app_urls.dart';
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
      final response = await _dio.get(AppUrls.getCourses);
      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        // print("response is 200");
        //var data = response.data["data"];
        //print(response.data["data"]);
        for (var x in response.data["data"]) {
          Course crs = Course.fromJson(x);
          //debugPrint("image url: ${x["thumbnail"] ?? "_"}");
          courses.add(crs);
        }
        courses.sort((courseA, courseB) =>
            courseA.title.toLowerCase().compareTo(courseB.title.toLowerCase()));
      }
    } on DioException catch (e) {
      String errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
    return courses;
  }

  Future<List<Course>> searchCourses(String searchQuery) async {
    int? statusCode;

    List<Course> courses = [];
    try {
      final response = await _dio.get(AppUrls.courseSearch,
          queryParameters: {"course_name": searchQuery});

      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        // print("response is 200");
        //var data = response.data["data"];
        //print(response.data["data"]);
        for (var x in response.data["data"]) {
          //print(x.runtimeType);
          Course crs = Course.fromJson(x);
          courses.add(crs);
        }

        courses.sort((courseA, courseB) =>
            courseA.title.toLowerCase().compareTo(courseB.title.toLowerCase()));
        debugPrint(
            "searched courses: [ ${courses.map((c) => c.title).join(",")} ]");
      }
    } on DioException catch (e) {
      String errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
    return courses;
  }
}
