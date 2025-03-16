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
      await _repository.markNotifAsRead(notification.id);
      final currentState = state.value!;
      List<NotificationData> updatedUnread = [];
      List<NotificationData> updatedRead = [];
      if (_currentType == NotifType.unread) {
        updatedUnread = currentState.unreadNotifs
            .where((n) => n.id != notification.id)
            .toList();
        updatedRead = [...currentState.readNotifs, notification];
      } else {
        updatedRead = currentState.readNotifs
            .where((n) => n.id != notification.id)
            .toList();
        updatedUnread = [...currentState.unreadNotifs, notification];
      }

      state = AsyncData(
        currentState.copyWith(
          unreadNotifs: updatedUnread,
          readNotifs: updatedRead,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
