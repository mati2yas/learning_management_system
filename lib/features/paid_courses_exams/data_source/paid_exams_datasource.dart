import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/app_urls.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/features/paid_courses_exams/model/paid_exam_model.dart';

final paidExamsDataSourceProvider = Provider<PaidExamsDataSource>((ref) {
  return PaidExamsDataSource(DioClient.instance);
});

class PaidExamsDataSource {
  final Dio _dio;
  PaidExamsDataSource(this._dio);

  Future<List<PaidExam>> fetchPaidExams() async {
    int? statusCode;
    List<PaidExam> courses = [];
    try {
      await DioClient.setToken();
      final response = await _dio.get(AppUrls.paidExams);
      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        // print("response is 200");
        //var data = response.data["data"];
        //print(response.data["data"]);
        for (var x in response.data["data"]) {
          //debugPrint("type of paid course json ${x.runtimeType}");
          PaidExam crs = PaidExam.fromJson(x);
          courses.add(crs);
        }
        courses.sort((a, b) => a.parentCourseTitle
            .toLowerCase()
            .compareTo(b.parentCourseTitle.toLowerCase()));
      }
    } on DioException catch (e) {
      String errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
    return courses;
  }
}
