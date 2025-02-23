import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';

final paidCoursesDataSourceProvider = Provider<PaidCoursesDataSource>((ref) {
  return PaidCoursesDataSource(DioClient.instance);
});

class PaidCoursesDataSource {
  final Dio _dio;
  PaidCoursesDataSource(this._dio);

  Future<List<Course>> fetchPaidCourses() async {
    int? statusCode;
    List<Course> courses = [];
    try {
      await DioClient.setToken();
      final response = await _dio.get("/paid-courses");
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

  Future<Response> toggleCourseLiked(Course course) async {
    int? statusCode;
    try {
      final response = await _dio.post("/toggle-like/${course.id}");
      debugPrint("${_dio.options.baseUrl}/toggle-like/${course.id}");
      statusCode = response.statusCode;
      return response;
    } on DioException catch (e) {
      String errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
  }

  Future<Response> toggleCourseSaved(Course course) async {
    int? statusCode;
    try {
      final response = await _dio.post("/toggle-save/${course.id}");
      debugPrint("${_dio.options.baseUrl}/toggle-save/${course.id}");
      statusCode = response.statusCode;
      return response;
    } on DioException catch (e) {
      String errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
  }
}
