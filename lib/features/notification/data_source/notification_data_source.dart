import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/app_urls.dart';
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
  Future<NotificationModel> fetchReadNotifs() async {
    NotificationModel notifs = NotificationModel(notifDatas: []);
    int? statusCode;
    try {
      debugPrint(
          "notifications fetch url: ${AppUrls.baseUrl}${AppUrls.unreadNotifications}");
      final response = await _dio.get(
        AppUrls.unreadNotifications,
      );

      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        debugPrint(response.data);
        var notifModel = NotificationModel.fromJson(response.data);
        notifs = notifModel;
      }
    } on DioException catch (e) {
      final errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }

    return notifs;
  }

  Future<NotificationModel> fetchUnreadNotifs() async {
    return NotificationModel(
      notifDatas: [],
      currentPage: 0,
      totalPages: 10,
    );
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
