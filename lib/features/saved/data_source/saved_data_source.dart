import 'package:dio/dio.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';

class SavedDataSource {
  final Dio _dio;
  SavedDataSource(this._dio);

  Future<List<Course>> getCourses() async {
    List<Course> courses = [];
    int? statusCode;
    try {
      
      final response = await _dio.get("/random-courses");
      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        var data = response.data["data"];

        for (var dataVl in data) {
          Course crs = Course.fromJson(dataVl);
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
