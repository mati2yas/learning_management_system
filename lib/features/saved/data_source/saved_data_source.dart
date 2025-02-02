import 'package:dio/dio.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';

class SavedDataSource {
  final Dio _dio;
  SavedDataSource(this._dio);

  Future<List<Course>> getCourses() async {
    List<Course> courses = [];
    //final Map<String, dynamic> mapVal = await getUserData();
    int? statusCode;
    //print(mapVal);
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
        courses = courses.take(5).toList();

        print("courses: \n ${courses.length}");
      }
    } on DioException catch (e) {
      final errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
    return courses;
  }
}
