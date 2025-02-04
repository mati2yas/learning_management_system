import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/features/subscription/model/subscription_model.dart';

final subscriptionDataSourceProvider = Provider<SubscriptionDataSource>((ref) {
  return SubscriptionDataSource(DioClient.instance);
});

class SubscriptionDataSource {
  final Dio _dio;
  SubscriptionDataSource(this._dio);

  Future<void> subscribe(SubscriptionModel request) async {
    FormData formData = await request.toFormData();
    int? statusCode;
    _dio.options.headers["Content-Type"] = "multipart/form-data";
    try {
      final response = await _dio.post(
        "/subscribe",
        data: formData,
      );
      statusCode = response.statusCode;
    } on DioException catch (e) {
      String errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
  }
}
