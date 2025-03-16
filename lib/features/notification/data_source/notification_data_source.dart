import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/app_urls.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/features/notification/model/notification_model.dart';
import 'package:lms_system/features/shared/model/api_response_model.dart';

final notificationDataSourceProvider = Provider<NotificationsDataSource>((ref) {
  return NotificationsDataSource(DioClient.instance);
});

class NotificationsDataSource {
  final Dio _dio;
  NotificationsDataSource(this._dio);
  Future<NotificationModel> fetchReadNotifs({required int page}) async {
    NotificationModel notifs = NotificationModel();
    int? statusCode;
    try {
      debugPrint(
          "notifications fetch url: ${AppUrls.baseUrl}${AppUrls.readNotifications}");
      await DioClient.setToken();

      _dio.options.headers['Content-Type'] = 'application/json';
      _dio.options.headers['Accept'] = 'application/json';
      final response = await _dio.get(
        AppUrls.unreadNotifications,
      );

      statusCode = response.statusCode;
      debugPrint("Dio response status code: $statusCode");
      debugPrint("Dio response headers: ${response.headers}");
      debugPrint(
          "Dio response data: ${response.data}"); // Log the entire response data

      if (response.statusCode == 200) {
        var notifModel = NotificationModel.fromJson(
          json: response.data,
          notificationType: NotifType.read,
        );
        notifs = notifModel;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint("Dio error response status: ${e.response!.statusCode}");
        debugPrint("Dio error response data: ${e.response!.data}");
      }
      final errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }

    return notifs;
  }

  Future<NotificationModel> fetchUnreadNotifs({required int page}) async {
    NotificationModel notifs = NotificationModel();
    int? statusCode;
    try {
      debugPrint(
          "notifications fetch url: ${AppUrls.baseUrl}${AppUrls.readNotifications}");
      await DioClient.setToken();

      _dio.options.headers['Content-Type'] = 'application/json';
      _dio.options.headers['Accept'] = 'application/json';
      final response = await _dio.get(
        AppUrls.unreadNotifications,
      );

      statusCode = response.statusCode;
      debugPrint("Dio response status code: $statusCode");
      debugPrint("Dio response headers: ${response.headers}");
      debugPrint(
          "Dio response data: ${response.data}"); // Log the entire response data

      if (response.statusCode == 200) {
        var notifModel = NotificationModel.fromJson(
          json: response.data,
          notificationType: NotifType.unread,
        );
        notifs = notifModel;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint("Dio error response status: ${e.response!.statusCode}");
        debugPrint("Dio error response data: ${e.response!.data}");
      }
      final errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }

    return notifs;
  }

  Future<ApiResponse> markAsRead(String notifId) async {
    ApiResponse responseVal = ApiResponse(
      message: "",
      responseStatus: false,
    );
    try {
      final response =
          await _dio.post("${AppUrls.markNotificationAsRead}/$notifId/read");
      if ([200, 201].contains(response.statusCode)) {
        return ApiResponse(
          message: "Successfully Marked as read",
          responseStatus: true,
        );
      } else {
        return ApiResponse(
          message: "Mark As Read Not Successful.",
          responseStatus: false,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return responseVal;
  }
}
