import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/features/notification/model/notification_model.dart';
import 'package:lms_system/features/notification/repository/notification_repository.dart';

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
  NotifType _currentType = NotifType.unread;

  NotificationApiNotifier(this._repository);

  @override
  Future<NotificationModel> build() async {
    return fetchNotifs(page: 1, type: NotifType.unread);
  }

  Future<NotificationModel> fetchNotifs(
      {required int page, required NotifType type}) async {
    _currentType = type;
    try {
      final notifModel = await _repository.getNotifs(page: page, type: type);
      return notifModel;
    } catch (e, stack) {
      debugPrint(e.toString());
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  Future<void> markAsRead(NotificationData notification) async {
    try {
      await _repository.markNotifAsRead(notification.id.toString());
      final currentState = state.value!;
      List<NotificationData> updatedNotifs = [];

      updatedNotifs =
          currentState.notifs.where((n) => n.id != notification.id).toList();

      state = AsyncData(
        currentState.copyWith(
          notifs: updatedNotifs,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
