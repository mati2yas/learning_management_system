import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/notification/model/notification_model.dart';

import '../data_source/notification_data_source.dart';
final notificationProvider =
    StateNotifierProvider<NotificationModelsNotifier, NotificationState>((ref) {
  final dataSource = ref.read(notifsDataSourceProvider);
  return NotificationModelsNotifier(dataSource);
});

final notifsDataSourceProvider = Provider<NotificationsDataSource>((ref) {
  return NotificationsDataSource();
});

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

class NotificationModelsNotifier extends StateNotifier<NotificationState> {
  final NotificationsDataSource dataSource;

  NotificationModelsNotifier(this.dataSource)
      : super(NotificationState.initial()) {
    loadNotifications();
  }

  void loadNotifications() {
    state = NotificationState(
      unreadNotifications: dataSource.fetchUnreadNotifs(),
      readNotifications: dataSource.fetchReadNotifs(),
    );
  }
}
