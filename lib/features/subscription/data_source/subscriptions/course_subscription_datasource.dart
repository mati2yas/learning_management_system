import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/app_urls.dart';
import 'package:lms_system/core/utils/dio_client.dart';

import '../../model/course_subscription_model.dart';

final courseSubscriptionDataSourceProvider =
    Provider<CourseSubscriptionDataSource>((ref) {
  return CourseSubscriptionDataSource(DioClient.instance);
});

class CourseSubscriptionDataSource {
  final Dio _dio;
  CourseSubscriptionDataSource(this._dio);

  Future<Response> subscribe(CourseSubscriptionModel request) async {
    FormData formData = await request.toFormData();
    int? statusCode;

    await DioClient.setToken();
    try {
      _dio.options.headers['Content-Type'] = 'multipart/form-data';
      final response = await _dio.post(
        AppUrls.courseSubscriptionRequest,
        data: formData,
      );
      statusCode = response.statusCode;
      return response;
    } on DioException catch (e) {
      //String errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(e.response!.data["message"]);
    }
  }
}
