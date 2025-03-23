import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/connectivity/connectivity_service.dart';
import 'package:lms_system/features/notification/data_source/notification_data_source.dart';
import 'package:lms_system/features/notification/model/notification_model.dart';
import 'package:lms_system/features/shared/model/api_response_model.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(
    ref.watch(notificationDataSourceProvider),
    ref.watch(connectivityServiceProvider),
  );
});

class NotificationRepository {
  final NotificationsDataSource _dataSource;
  final ConnectivityService _connectivityService;

  NotificationRepository(this._dataSource, this._connectivityService);

  Future<NotificationModel> getNotifs({required int page}) async {
    if (!await _connectivityService.hasConnection()) {
      throw Exception("No internet connection");
    }
    return await _dataSource.fetchUnreadNotifs(page: page);
  }

  Future<ApiResponse> markNotifAsRead(String notifId) async {
    if (!await _connectivityService.hasConnection()) {
      throw Exception("No Internet");
    }

    return await _dataSource.markAsRead(notifId);
  }
}
