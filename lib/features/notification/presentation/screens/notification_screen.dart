import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/async_error_widget.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/features/notification/model/notification_model.dart';
import 'package:number_pagination/number_pagination.dart';

import '../../provider/notification_provider.dart';

//

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int lowestPage = 0, highestPage = 3;

  int lowestPageLimit = 0, highestPageLimit = 10;
  int currentPage = 1;
  String increaseStr = "increase", decreaseStr = "decrease";
  String oneStep = "oneStep", jumpStep = "jumpStep", step = "oneStep";
  @override
  Widget build(BuildContext context) {
    var textTh = Theme.of(context).textTheme;
    final apiState = ref.watch(notificationApiProvider);
    final notifsController = ref.watch(notificationApiProvider.notifier);
    var size = MediaQuery.of(context).size;
    final notificationState = ref.watch(notificationApiProvider);
    final isLoading =
        ref.watch(notificationApiProvider.select((state) => state.isLoading));
    final notificationData = ref.watch(notificationApiProvider).valueOrNull;
    final totalPages = notificationData?.totalPages ?? 10;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,
        elevation: 5,
        shadowColor: Colors.black87,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Expanded(
                child: apiState.when(
                  loading: () => SizedBox(
                    height: size.height * 0.7,
                    width: size.width,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (error, stack) => AsyncErrorWidget(
                    errorMsg: error.toString(),
                    callback: () async {
                      await ref
                          .refresh(notificationApiProvider.notifier)
                          .fetchNotifs(page: currentPage);
                    },
                  ),
                  data: (notifs) {
                    return notifs.notifs.isEmpty
                        ? Center(
                            child: Text(
                              "No Notifications Yet.",
                              style: textTh.bodyLarge!
                                  .copyWith(fontWeight: FontWeight.w700),
                            ),
                          )
                        : _buildNotificationList(
                            notifs.notifs, NotifType.unread, ref);
                  },
                ),
              ),
              if (notificationData != null &&
                  notificationData.notifs.isNotEmpty)
                NumberPagination(
                  selectedButtonColor: AppColors.mainBlue,
                  buttonRadius: 6,
                  onPageChanged: (number) {
                    setState(() {
                      currentPage = number;
                    });
                    notifsController.fetchNotifs(page: number);
                  },
                  totalPages: 10,
                  currentPage: currentPage,
                  visiblePagesCount: 4,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationApiProvider.notifier).fetchNotifs(page: 1);
    });
  }

  Widget _buildNotificationList(
      List<NotificationData> notifications, NotifType type, WidgetRef ref) {
    return ListView.separated(
      itemCount: notifications.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return ListTile(
          leading: const Icon(Icons.notifications_outlined,
              color: AppColors.mainBlue, size: 30),
          title: Text(notification.title),
          subtitle: Text(notification.content),
          trailing: PopupMenuButton<void>(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) {
              return <PopupMenuEntry<void>>[
                PopupMenuItem<void>(
                  onTap: () async {
                    await ref
                        .read(notificationApiProvider.notifier)
                        .markAsRead(notification);
                  },
                  child: const ListTile(
                    leading: Icon(Icons.mark_as_unread),
                    title: Text("Mark As Read"),
                  ),
                ),
              ];
            },
          ),
        );
      },
    );
  }
}
