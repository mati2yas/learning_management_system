import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/features/requests/presentation/widgets/subscription_widget.dart';
import 'package:lms_system/features/requests/provider/requests_provider.dart';

import '../widgets/request_tile.dart';

class RequestsScreen extends ConsumerStatefulWidget {
  const RequestsScreen({super.key});

  @override
  ConsumerState<RequestsScreen> createState() => _RequestScreenState();
}

enum SubscriptionType { oneMonth, threeMonths, sixMonths, yearly }

class _RequestScreenState extends ConsumerState<RequestsScreen> {
  SubscriptionType subscriptionType = SubscriptionType.oneMonth;
  XFile? transactionImage;
  bool imagePicked = false;
  Map<SubscriptionType, double> subTypeValue = {
    SubscriptionType.oneMonth: 10,
    SubscriptionType.threeMonths: 30,
    SubscriptionType.sixMonths: 60,
    SubscriptionType.yearly: 120,
  };

  @override
  Widget build(BuildContext context) {
    var textTh = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;
    var listViewSize = size.width * 0.5;
    var requestsProv = ref.watch(requestsProvider);
    double price = requestsProv
        .map((r) => r.price[subscriptionType] ?? 0)
        .reduce((init, sum) => init + sum);
    price *= subTypeValue[subscriptionType]!;
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
              height: size.height * 0.5,
              width: size.width * 0.85,
              child: ListView.builder(
                itemCount: requestsProv.length,
                itemBuilder: (_, index) {
                  var request = requestsProv[index];
                  return RequestTile(
                    selectedPriceType:
                        requestsProv[index].price[subscriptionType] ?? 0,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SubscriptionWidget(
                      isActive: subscriptionType == SubscriptionType.oneMonth,
                      onPress: () {
                        setState(() {
                          subscriptionType = SubscriptionType.oneMonth;
                        });
                      },
                      duration: 1,
                    ),
                    SubscriptionWidget(
                      isActive:
                          subscriptionType == SubscriptionType.threeMonths,
                      onPress: () {
                        setState(() {
                          subscriptionType = SubscriptionType.threeMonths;
                        });
                      },
                      duration: 3,
                    ),
                    SubscriptionWidget(
                      isActive: subscriptionType == SubscriptionType.sixMonths,
                      onPress: () {
                        setState(() {
                          subscriptionType = SubscriptionType.sixMonths;
                        });
                      },
                      duration: 6,
                    ),
                    SubscriptionWidget(
                      isActive: subscriptionType == SubscriptionType.yearly,
                      onPress: () {
                        setState(() {
                          subscriptionType = SubscriptionType.yearly;
                        });
                      },
                      duration: 12,
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: size.width * 0.6,
                  child: Column(
                    children: [
                      Text(
                        "${requestsProv.length} courses requested.",
                        style: textTh.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Total price: ${price.toStringAsFixed(2)}",
                        style: textTh.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: () async {
                          bool success = await pickTransactionImage();
                          if (success) {
                            setState(() {
                              imagePicked = true;
                              listViewSize = size.height * 0.35;
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.mainBlue.withAlpha(100),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          height: 30,
                          width: size.width * 0.4,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Choose Image"),
                              Icon(
                                Icons.image,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (imagePicked && transactionImage != null)
                        Image.file(
                          File(transactionImage!.path),
                          width: 50,
                          height: 50,
                        ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainBlue,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 7,
                          ),
                          fixedSize: Size(size.width * 0.4, 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * 0.04,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> pickTransactionImage() async {
    final XFile? image = await showImagePickSheet();
    if (image != null) {
      transactionImage = XFile(image.path);
      return true;
    }
    return false;
  }

  Future<XFile?> showImagePickSheet() async {
    final picker = ImagePicker();
    return await showModalBottomSheet<XFile?>(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          height: 120,
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () async {
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.camera);
                  if (image != null && context.mounted) {
                    Navigator.pop(context, image);
                  }
                },
                child: const SizedBox(
                  height: 80,
                  width: 60,
                  child: Column(
                    children: [
                      Icon(Icons.image),
                      Text("From Camera"),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (image != null && context.mounted) {
                    Navigator.pop(context, image);
                  }
                },
                child: const SizedBox(
                  height: 80,
                  width: 60,
                  child: Column(
                    children: [
                      Icon(Icons.image),
                      Text("From Gallery"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
