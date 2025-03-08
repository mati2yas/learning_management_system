import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/app_urls.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/features/notification/model/notification_model.dart';

final notificationDataSourceProvider = Provider<NotificationsDataSource>((ref) {
  return NotificationsDataSource(DioClient.instance);
});

class NotificationsDataSource {
  final Dio _dio;
  NotificationsDataSource(this._dio);
  Future<List<NotificationModel>> fetchReadNotifs() async {
    List<NotificationModel> notifs = [];
    int? statusCode;
    try {
      final response = await _dio.get(
        AppUrls.notifications,
      );

      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        List<dynamic> data = response.data["data"];
        for (var d in data) {
          debugPrint(d["something"]);
        }
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
}
