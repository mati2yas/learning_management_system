import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/requests/provider/requests_provider.dart';

import '../widgets/request_tile.dart';

class RequestsScreen extends ConsumerWidget {
  const RequestsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTh = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;
    var requestsProv = ref.read(requestsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buy Course"),
        centerTitle: true,
        elevation: 5,
        shadowColor: Colors.black87,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: size.height * 0.6,
              width: size.width * 0.85,
              child: ListView.builder(
                itemCount: requestsProv.length,
                itemBuilder: (_, index) {
                  var request = requestsProv[index];
                  return RequestTile(
                    course: request,
                    textTh: textTh,
                  );
                },
              ),
            ),
            Center(
              child: SizedBox(
                height: 100,
                width: size.width * 0.8,
                child: const Row(
                  children: [
                    SubscriptionWidget(duration: 1),
                    SubscriptionWidget(duration: 3),
                    SubscriptionWidget(duration: 6),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubscriptionWidget extends StatelessWidget {
  final int duration;
  const SubscriptionWidget({
    super.key,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.mainBlue,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text("$duration"),
          const SizedBox(
            height: 20,
          ),
          const Text("Months"),
        ],
      ),
    );
  }
}
