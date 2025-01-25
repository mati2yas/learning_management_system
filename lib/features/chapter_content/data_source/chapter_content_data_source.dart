import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/api_constants.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/features/chapter_content/model/chapter_content_model.dart';

final chapterContentDataSourceProvider =
    Provider<ChapterContentDataSource>((ref) {
  return ChapterContentDataSource(DioClient.instance);
});

class ChapterContentDataSource {
  final Dio _dio;
  ChapterContentDataSource(this._dio);

  Future<ChapterContent> fetchChapterContent(String chapterId) async {
    ChapterContent content = ChapterContent(videos: [], documents: []);
    int? statusCode;
    print("fetchChapterContent called");
    try {
      final response = await _dio.get("/chapter-contents/$chapterId");
      print("${ApiConstants.baseUrl}/chapter-contents/$chapterId");
      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        content = ChapterContent.fromJson(response.data["data"]);
      }
    } on DioException catch (e) {
      String errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
    return content;
  }
}
