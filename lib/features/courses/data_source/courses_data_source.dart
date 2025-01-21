import 'package:dio/dio.dart';
import 'package:lms_system/core/utils/shared_pref/shared_pref.dart';

import '../../shared/model/shared_course_model.dart';

class CourseDataSource {
  final Dio _dio;
  CourseDataSource(this._dio);

  Future<List<Course>> fetchCourses() async {
    var token = await SharedPrefService.getUserToken();
    // _dio.options.headers.addEntries(
    //   {MapEntry("Authorization", "Bearer $token")},
    // );

    List<Course> courses = [];
    try {
      final response = await _dio.get("/random-course");

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
      throw Exception("API Error: ${e.message}");
    }
    return courses;
  }

  
}
