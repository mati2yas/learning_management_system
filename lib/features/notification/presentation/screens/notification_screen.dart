import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/async_error_widget.dart';
import 'package:lms_system/core/common_widgets/common_app_bar.dart';
import 'package:lms_system/core/constants/app_colors.dart';

import '../../provider/notification_provider.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiState = ref.watch(notificationApiProvider);
    var size = MediaQuery.of(context).size;
    final notificationState = ref.watch(notificationApiProvider);
    final isLoading =
        ref.watch(notificationApiProvider.select((state) => state.isLoading));
    final notificationData = ref.watch(notificationApiProvider).valueOrNull;
    final currentPage = notificationData?.currentPage ?? 0;
    final totalPages = notificationData?.totalPages ?? 10;

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
                apiState.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.mainBlue,
                      strokeWidth: 5,
                    ),
                  ),
                  error: (error, stack) => AsyncErrorWidget(
                    errorMsg: error.toString().replaceAll("Exception: ", ""),
                    callback: () async {
                      await ref
                          .refresh(notificationApiProvider.notifier)
                          .fetchNotifs(page: 0);
                    },
                  ),
                  data: (notifs) {
                    return Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            flex: 18,
                            child: ListView.separated(
                              itemCount: notifs.notifDatas.length,
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemBuilder: (context, index) {
                                final notification = notifs.notifDatas[index];
                                return ListTile(
                                  leading: const Icon(
                                    Icons.notifications_outlined,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                  title: Text(notification.title),
                                  subtitle: Text(notification.content),
                                  trailing: FilledButton(
                                    style: FilledButton.styleFrom(
                                      backgroundColor:
                                          AppColors.mainBlueLighter,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    onLongPress: () {},
                                    onPressed: () {},
                                    child: const Text("Mark as read"),
                                  ),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (currentPage > 1)
                                    TextButton(
                                      onPressed: () async {
                                        await ref
                                            .read(notificationApiProvider
                                                .notifier)
                                            .fetchNotifs(page: currentPage - 1);
                                      },
                                      child: const Text('Previous'),
                                    ),
                                  if (currentPage < totalPages)
                                    TextButton(
                                      onPressed: () async {
                                        await ref
                                            .read(notificationApiProvider
                                                .notifier)
                                            .fetchNotifs(page: currentPage + 1);
                                      },
                                      child: const Text('Next'),
                                    ),
                                  if (isLoading)
                                    const Padding(
                                      padding: EdgeInsets.only(left: 16.0),
                                      child: CircularProgressIndicator(
                                        color: AppColors.mainBlue,
                                        strokeWidth: 5,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
 //