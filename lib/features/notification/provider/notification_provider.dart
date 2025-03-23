import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  NotificationApiNotifier(this._repository);

  @override
  Future<NotificationModel> build() async {
    return fetchNotifs(page: 1);
  }

  Future<NotificationModel> fetchNotifs({required int page}) async {
    try {
      debugPrint("called fetchNotifs with current page: $page");
      final notifModel = await _repository.getNotifs(page: page);
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
