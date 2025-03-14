import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/features/notification/model/notification_model.dart';
import 'package:lms_system/features/notification/repository/notification_repository.dart';
import 'package:lms_system/features/shared/model/api_response_model.dart';

final notificationApiNotifierProvider = Provider(
    (ref) => NotificationApiNotifier(ref.read(notificationRepositoryProvider)));

final notificationApiProvider =
    AsyncNotifierProvider<NotificationApiNotifier, NotificationModel>(
  () {
    final container = ProviderContainer(
      overrides: [
        notificationRepositoryProvider,
      ],
    );
    return container.read(notificationApiNotifierProvider);
  },
);

class NotificationApiNotifier extends AsyncNotifier<NotificationModel> {
  final NotificationRepository _repository;

  NotificationApiNotifier(this._repository);

  @override
  Future<NotificationModel> build() async {
    return fetchNotifs(page: 0);
  }

  Future<NotificationModel> fetchNotifs({required int page}) async {
    try {
      final notifModel = await _repository.getNotifs();
      return notifModel;
    } catch (e, stack) {
      debugPrint(e.toString());
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  fetchNotifsPerPage({required page}) {}

  Future<ApiResponse> markAsRead(NotificationData notification) async {
    await DioClient.setToken();
    ApiResponse apiRes = ApiResponse(
      message: "Waiting",
      responseStatus: false,
    );
    try {
      apiRes = await _repository.markNotifAsRead(notification.id);
    } catch (e) {
      apiRes = ApiResponse(
        message: "Failed",
        responseStatus: false,
      );
    }
    return apiRes;
  }
}

class NotificationState {
  final List<NotificationModel> unreadNotifications;
  final List<NotificationModel> readNotifications;

  NotificationState({
    required this.unreadNotifications,
    required this.readNotifications,
  });

  NotificationState.initial()
      : unreadNotifications = [],
        readNotifications = [];
}
