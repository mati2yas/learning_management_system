import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/app_urls.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/features/shared/model/shared_user.dart';

import '../../shared/model/shared_course_model.dart';

final homeDataSourceProvider = Provider<HomeDataSource>((ref) {
  return HomeDataSource(DioClient.instance);
});

class HomeDataSource {
  final Dio _dio;
  HomeDataSource(this._dio);

  Future<List<Course>> getCourses() async {
    List<Course> courses = [];
    User? userr;
    int? statusCode;
    try {
      //var user = await SecureStorageService().getUserFromStorage();
      //userr = user;
      ////debugPrint("HomePageApi Token: ${user?.token}");

      await DioClient.setToken();
      debugPrint(
          "diotoken in homepage: ${_dio.options.headers["Authorization"]}");

      var dioTok = (_dio.options.headers["Authorization"] ?? "") as String;
      dioTok = dioTok.replaceAll("Bearer", "");
      if (dioTok == "" || dioTok.length < 10) {
        statusCode = 00;
        throw Exception("Token not set yet");
      }

      _dio.options.headers['Accept'] = 'application/json';

      // if (["", null].contains(user?.token)) {
      //   statusCode = 00;
      //   throw Exception("Token not set yet");
      // }
      final response = await _dio.get(
        AppUrls.homePageCourses,
      );
      statusCode = response.statusCode;
      //debugPrint("in homepage statuscode: ${response.statusCode}");
      if (response.statusCode == 200) {
        //dynamic data1 = [];

        List<dynamic> data1 = response.data["data"];
        ////debugPrint("${data1.length} values");

        for (var dataVl in data1) {
          //print(dataVl);
          //debugPrint("image url: ${dataVl["thumbnail"] ?? "_"}");
          Course crs = Course.fromJson(dataVl);
          //print(crs.title);

          courses.add(crs);
        }

        courses.sort((courseA, courseB) =>
            courseA.title.toLowerCase().compareTo(courseB.title.toLowerCase()));
        //debugPrint("courses length: \n ${courses.length}");
      }
    } on DioException catch (e) {
      String errorMsg = e.message ?? "no error message";
      String errorResMsg = e.response?.statusMessage ?? "no status message";
      debugPrint(
          "in homepage exception for token ${(userr?.token ?? "000").substring(0, 3)}: \n error message: $errorMsg, \n errorStatusMessage: $errorResMsg");
      final errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
    return courses;
  }
}
