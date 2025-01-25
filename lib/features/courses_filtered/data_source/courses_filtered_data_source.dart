import 'package:dio/dio.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';

class CoursesFilteredDataSource {
  final Dio _dio;
  CoursesFilteredDataSource(this._dio);

  Future<List<Course>> fetchCoursesFiltered(String filter) async {
    List<Course> courses = [];
    try {
      final response = await _dio.get("/random-courses/$filter");

      if (response.statusCode == 200) {
        for (var x in response.data["data"]) {
          x["category"] = {"name": filter};
          courses.add(Course.fromJson(x));
        }
      }
    } on DioException catch (e) {
      throw Exception("API Error: ${e.message}");
    }
    return courses;
  }
}
