import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/model/shared_course_model.dart';

final homeDataSourceProvider = Provider<HomeDataSource>((ref) {
  return HomeDataSource(DioClient.instance);
});
class HomeDataSource {
  final Dio _dio;
  HomeDataSource(this._dio);

  Future<List<Course>> getCourses() async {
    final prefs = await SharedPreferences.getInstance();

    List<Course> courses = [];
    final Map<String, dynamic> mapVal = await getUserData();
    int? statusCode;
    print(mapVal);
    try {
      //var token = mapVal["token"];
      //print("token: $token");
      //_dio.options.headers = {"Authorization": "Bearer $token"};
      final response = await _dio.get("/random-courses");
      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        var data = response.data["data"];

        for (var dataVl in data) {
          //print(dataVl);
          Course crs = Course.fromJson(dataVl);
          //print(crs.title);

          courses.add(crs);
        }

        print("courses: \n ${courses.length}");
      }
    } on DioException catch (e) {
      final errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
    return courses;
  }

  Future<Map<String, dynamic>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    var userDataString = prefs.getString("userData") ?? "{}";

    userDataString = userDataString.replaceAll('\'', '"');
    userDataString = userDataString.replaceAllMapped(
      RegExp(
          r'(?<=[:\s{,])([a-zA-Z0-9_.@]+|\d[a-zA-Z0-9_.|]+[\d]+)(?=[,\s}])'), // Modified regex
      (match) => '"${match.group(0)}"', // Wrap in double quotes
    );
    // var mapVal = jsonDecode(userDataString);
    // mapVal["password"] = "12345678";
    // userDataString = jsonEncode(mapVal);
    // print("userDataString: $userDataString");
    prefs.setString("userData", userDataString);
    // Parse the JSON string into a Map
    try {
      final Map<String, dynamic> userData = jsonDecode(userDataString);
      return userData;
    } catch (e) {
      print("Error decoding user data: $e");
    }
    return {}; // Return an empty map if no data or error
  }
}
