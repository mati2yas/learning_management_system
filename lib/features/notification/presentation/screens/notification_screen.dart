import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/async_error_widget.dart';
import 'package:lms_system/core/common_widgets/common_app_bar.dart';
import 'package:lms_system/core/constants/colors.dart';

import '../../provider/notification_provider.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiState = ref.watch(notificationApiProvider);
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
                // const Text(
                //   "Unread Notifications",
                //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                // ),
                apiState.when(
                    loading: () => const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.mainBlue,
                            strokeWidth: 5,
                          ),
                        ),
                    error: (error, stack) => AsyncErrorWidget(
                          errorMsg:
                              error.toString().replaceAll("Exception: ", ""),
                          callback: () async {
                            await ref
                                .read(notificationApiProvider.notifier)
                                .fetchNotifs();
                          },
                        ),
                    data: (notifs) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: notifs.length,
                          itemBuilder: (context, index) {
                            final notification = notifs[index];
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
                      );
                    }),
                // const Text(
                //   "Read Notifications",
                //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                // ),
                // Expanded(
                //   child: ListView.builder(
                //     itemCount: notificationState.readNotifications.length,
                //     itemBuilder: (context, index) {
                //       final notification =
                //           notificationState.readNotifications[index];
                //       return ListTile(
                //         leading: const Icon(
                //           Icons.notifications,
                //           color: Colors.grey,
                //           size: 30,
                //         ),
                //         title: Text(notification.title),
                //         subtitle: Text(notification.content),
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
