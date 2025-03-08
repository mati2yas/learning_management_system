import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/app_urls.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/core/utils/error_handling.dart';
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
    int? statusCode;

    try {
      final response = await _dio.get("${AppUrls.courseChapters}/$courseId");
      print("${AppUrls.baseUrl}${AppUrls.courseChapters}/$courseId");
      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        for (var d in response.data["data"]) {
          print(d);
          chapters.add(Chapter.fromJson(d));
        }
      }
    } on DioException catch (e) {
      String errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
    return chapters;
  }
}
