import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/app_urls.dart';
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
    ChapterContent content =
        ChapterContent(order: -1, videos: [], documents: [], quizzes: []);
    int? statusCode;
    //debugPrint("fetchChapterContent called");
    try {
      final response = await _dio.get("${AppUrls.chapterContent}/$chapterId");
      //debugPrint("${AppUrls.baseUrl}/${AppUrls.chapterContent}/$chapterId");
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
