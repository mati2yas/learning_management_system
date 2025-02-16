import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/db_service.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/core/utils/storage_service.dart';

import '../../shared/model/shared_course_model.dart';

final homeDataSourceProvider = Provider<HomeDataSource>((ref) {
  return HomeDataSource(DioClient.instance);
});

class HomeDataSource {
  final Dio _dio;
  HomeDataSource(this._dio);

  Future<List<Course>> getCourses() async {
    List<Course> courses = [];
    int? statusCode;
    try {
      
      var user = await SecureStorageService().getUserFromStorage();
      var token = user?.token;

      if (token != null) {
        DioClient.setToken(token);
        debugPrint("token: $token");
        print("token: $token");
      }
      print("token: $token");

      _dio.options.headers['Accept'] = 'application/json';
      final response = await _dio.get("/homepage/courses");
      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        List<dynamic> data = response.data["data"];
        debugPrint("${data.length} values");

        for (var dataVl in data) {
          //print(dataVl);
          Course crs = Course.fromJson(dataVl);
          //print(crs.title);

          courses.add(crs);
        }

        print("courses length: \n ${courses.length}");
      }
    } on DioException catch (e) {
      final errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
    return courses;
  }
}
