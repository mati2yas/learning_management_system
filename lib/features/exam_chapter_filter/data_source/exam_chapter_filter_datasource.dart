import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/app_urls.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/core/utils/util_functions.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';

final examChapterFilterDataSourceProvider =
    Provider<ExamChapterFilterDataSource>(
        (ref) => ExamChapterFilterDataSource(DioClient.instance));

class ExamChapterFilterDataSource {
  final Dio _dio;
  ExamChapterFilterDataSource(this._dio);

  Future<List<ExamChapter>> fetchExamChapters({
    required int yearId,
    required int courseId,
  }) async {
    List<ExamChapter> examChapters = [];
    int? statusCode;
    try {
      final response =
          await _dio.get("${AppUrls.examChapterFilter}/$courseId/$yearId");
      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        var data = response.data["data"];
        //debugPrint("exam grade data:");
        for (var d in data) {
          if (d == data.first) {
            UtilFunctions().printMapData(d);
          }
          examChapters.add(ExamChapter.fromJson(d));
        }
      }
    } on DioException catch (e) {
      final errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
    return examChapters;
  }
}
