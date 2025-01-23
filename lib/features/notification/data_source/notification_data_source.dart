import 'package:lms_system/features/notification/model/notification_model.dart';

class NotificationsDataSource {
  List<NotificationModel> fetchReadNotifs() {
    return [
      NotificationModel(
        title:
            "Lorem ipsum d olor sit amet consectetur.  Lorem ipsum dolor sit amet consectetur.",
        content:
            "Lorem ipsum d olor sit amet consectetur.  Lorem ipsum dolor sit amet consectetur.",
      ),
      NotificationModel(
        title:
            "Lorem ipsum d olor sit amet consectetur.  Lorem ipsum dolor sit amet consectetur.",
        content:
            "Lorem ipsum d olor sit amet consectetur.  Lorem ipsum dolor sit amet consectetur.",
      ),
      NotificationModel(
        title:
            "Lorem ipsum d olor sit amet consectetur.  Lorem ipsum dolor sit amet consectetur.",
        content:
            "Lorem ipsum d olor sit amet consectetur.  Lorem ipsum dolor sit amet consectetur.",
      ),
    ];
  }

  List<NotificationModel> fetchUnreadNotifs() {
    return [
      NotificationModel(
        title:
            "Lorem ipsum d olor sit amet consectetur.  Lorem ipsum dolor sit amet consectetur.",
        content:
            "Lorem ipsum d olor sit amet consectetur.  Lorem ipsum dolor sit amet consectetur.",
      ),
      NotificationModel(
        title:
            "Lorem ipsum d olor sit amet consectetur.  Lorem ipsum dolor sit amet consectetur.",
        content:
            "Lorem ipsum d olor sit amet consectetur.  Lorem ipsum dolor sit amet consectetur.",
      ),
      NotificationModel(
        title:
            "Lorem ipsum d olor sit amet consectetur.  Lorem ipsum dolor sit amet consectetur.",
        content:
            "Lorem ipsum d olor sit amet consectetur.  Lorem ipsum dolor sit amet consectetur.",
      ),
    ];
  }
}
