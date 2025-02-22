import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/notification/model/notification_model.dart';

final notificationDataSourceProvider = Provider<NotificationsDataSource>((ref) {
  return NotificationsDataSource();
});

class NotificationsDataSource {
  Future<List<NotificationModel>> fetchReadNotifs() async {
    await Future.delayed(const Duration(seconds: 3));
    return [
      NotificationModel(
        title: "Request Rejected",
        content:
            "Subscription for 4 courses has been rejected. The transaction id does not exist",
      ),
      NotificationModel(
        title: "Request Rejected",
        content:
            "Subscription for 4 courses has been rejected. The transaction id and proof image do not match",
      ),
      NotificationModel(
        title: "Request Accepted",
        content: "Subscription for 3 courses accepted",
      ),
      NotificationModel(
        title: "Subscription Expires",
        content:
            "Your subscription for biology course of Grade 9 expires in 10 days",
      ),
    ];
  }

  Future<List<NotificationModel>> fetchUnreadNotifs() async {
    await Future.delayed(const Duration(seconds: 3));
    return [
      NotificationModel(
        title: "Request Rejected",
        content:
            "Subscription for 4 courses has been rejected. The transaction id does not exist",
      ),
      NotificationModel(
        title: "Request Rejected",
        content:
            "Subscription for 4 courses has been rejected. The transaction id and proof image do not match",
      ),
      NotificationModel(
        title: "Request Accepted",
        content: "Subscription for 3 courses accepted",
      ),
      NotificationModel(
        title: "Subscription Expires",
        content:
            "Your subscription for biology course of Grade 9 expires in 10 days",
      ),
    ];
  }
}
