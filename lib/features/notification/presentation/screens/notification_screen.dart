import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/common_app_bar.dart';

import '../../provider/notification_provider.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(notificationProvider);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(titleText: "Notifications"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Unread Notifications",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: notificationState.unreadNotifications.length,
                    itemBuilder: (context, index) {
                      final notification =
                          notificationState.unreadNotifications[index];
                      return ListTile(
                        leading: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.black,
                          size: 30,
                        ),
                        title: Text(notification.title),
                        subtitle: Text(notification.content),
                      );
                    },
                  ),
                ),
                const Text(
                  "Read Notifications",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: notificationState.readNotifications.length,
                    itemBuilder: (context, index) {
                      final notification =
                          notificationState.readNotifications[index];
                      return ListTile(
                        leading: const Icon(
                          Icons.notifications,
                          color: Colors.grey,
                          size: 30,
                        ),
                        title: Text(notification.title),
                        subtitle: Text(notification.content),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
