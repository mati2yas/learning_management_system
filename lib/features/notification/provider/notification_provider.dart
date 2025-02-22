import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/notification/model/notification_model.dart';
import 'package:lms_system/features/notification/repository/notification_repository.dart';

final notificationApiNotifierProvider = Provider(
    (ref) => NotificationApiNotifier(ref.read(notificationRepositoryProvider)));

final notificationApiProvider =
    AsyncNotifierProvider<NotificationApiNotifier, List<NotificationModel>>(
  () {
    final container = ProviderContainer(
      overrides: [
        notificationRepositoryProvider,
      ],
    );
    return container.read(notificationApiNotifierProvider);
  },
);

class NotificationApiNotifier extends AsyncNotifier<List<NotificationModel>> {
  final NotificationRepository _repository;

  NotificationApiNotifier(this._repository);

  @override
  Future<List<NotificationModel>> build() async {
    return fetchNotifs();
  }

  Future<List<NotificationModel>> fetchNotifs() async {
    try {
      final notifs = await _repository.getNotifs();
      return notifs;
    } catch (e, stack) {
      debugPrint(e.toString());
      state = AsyncError(e, stack);
      rethrow;
    }
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
