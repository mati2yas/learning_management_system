import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/api_constants.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/features/shared/model/chapter.dart';

final courseChaptersDataSourceProvider =
    Provider<CourseChaptersDataSource>((ref) {
  return CourseChaptersDataSource(DioClient.instance);
});

class CourseChaptersDataSource {
  final Dio _dio;
  CourseChaptersDataSource(this._dio);
  Future<List<Chapter>> fetchCourseChapters(String courseId) async {
    print("fetchCourseChapters called");
    List<Chapter> chapters = [];
  

    try {
      final response = await _dio.get("/course-chapters/$courseId");
      print("${ApiConstants.baseUrl}/course-chapters/$courseId");
      if (response.statusCode == 200) {
        for (var d in response.data["data"]) {
          print(d);
          chapters.add(Chapter.fromJson(d));
        }
      }
    } on DioException catch (e) {
      throw Exception("API Error: ${e.message}");
    }
    return chapters;
  }
}
