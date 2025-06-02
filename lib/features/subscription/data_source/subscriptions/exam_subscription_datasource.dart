import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/app_urls.dart';
import 'package:lms_system/core/utils/dio_client.dart';

import '../../model/exam_subscription_model.dart';

final examSubscriptionDataSourceProvider =
    Provider<ExamSubscriptionDataSource>((ref) {
  return ExamSubscriptionDataSource(DioClient.instance);
});

class ExamSubscriptionDataSource {
  final Dio _dio;
  ExamSubscriptionDataSource(this._dio);

  Future<Response> subscribe(ExamSubscriptionModel request) async {
    FormData formData = await request.toFormData();
    int? statusCode;
    debugPrint(
        "in exam sub datasource: current exam ids: [ ${request.examYears.map((yr) => yr.examSheetId).toList().join(",")} ]");
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          //debugPrint("➡️ Request: ${options.method} ${options.uri}");
          //debugPrint("Headers: ${options.headers}");
          //debugPrint("Body: ${options.data}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          //debugPrint("✅ Response: ${response.statusCode}");
          //debugPrint("✅ Response Time: ${response.extra["duration"]} ms");
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          //debugPrint("❌ Error: ${e.response?.statusCode}");
          //debugPrint("Message: ${e.response?.data}");
          return handler.next(e);
        },
      ),
    );

    await DioClient.setToken();
    //debugPrint("➡️ Request: POST /subscription-request");
    //debugPrint("Headers: ${_dio.options.headers}");
    //debugPrint("Body: ${formData.fields}");
    try {
      _dio.options.headers['Content-Type'] = 'multipart/form-data';
      final response = await _dio.post(
        AppUrls.examSubscriptionRequest,
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
