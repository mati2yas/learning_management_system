import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/utils/util_functions.dart';
import 'package:lms_system/features/home/provider/home_api_provider.dart';
import 'package:lms_system/features/paid_courses_exams/provider/paid_courses_provider.dart';
import 'package:lms_system/features/requests/presentation/widgets/course_request_tile.dart';
import 'package:lms_system/features/requests/presentation/widgets/subscription_widget.dart';
import 'package:lms_system/features/subscription/provider/subscriptions/course_subscription_provider.dart';

import '../../provider/requests/course_requests_provider.dart';

class CoursesSubscribePage extends ConsumerStatefulWidget {
  const CoursesSubscribePage({super.key});

  @override
  ConsumerState<CoursesSubscribePage> createState() =>
      _CourseSubscribePageState();
}

class _CourseSubscribePageState extends ConsumerState<CoursesSubscribePage> {
  SubscriptionType subscriptionType = SubscriptionType.oneMonth;
  XFile? transactionImage;
  bool imagePicked = false;
  final TextEditingController _transactionIdController =
      TextEditingController();
  String? _errorMessageTransactionId, _errorMessageImagePath;
  @override
  Widget build(BuildContext context) {
    var textTh = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;
    var requestsProv = ref.read(courseRequestsProvider);

    var subscriptionProv = ref.watch(courseSubscriptionControllerProvider);
    var subscriptionController =
        ref.watch(courseSubscriptionControllerProvider.notifier);
    double price = 0;
    if (requestsProv.isNotEmpty) {
      price = requestsProv
          .map((r) => r.getPriceBySubscriptionType(subscriptionType))
          .reduce((init, sum) => init + sum);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Center(
        child: SizedBox(
          height: size.height * 0.8,
          width: size.width * 0.85,
          child: ListView(
            children: [
              if (requestsProv.isEmpty)
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 100,
                    child: Text(
                      "No Courses In Cart",
                      style: textTh.bodyLarge!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              else
                for (int index = 0; index < requestsProv.length; index++)
                  CourseRequestTile(
                    onTap: () async {
                      if (requestsProv.isNotEmpty) {
                        var (status, courses) = await ref
                            .read(courseRequestsProvider.notifier)
                            .addOrRemoveCourse(requestsProv[index]);

                        subscriptionController.updateCourses(requestsProv);
                        ScaffoldMessenger.of(context).showSnackBar(
                          UtilFunctions.buildInfoSnackbar(
                              message: "Course has been $status"),
                        );
                      } else {
                        // If the list is empty, you can handle this case here
                        ScaffoldMessenger.of(context).showSnackBar(
                          UtilFunctions.buildErrorSnackbar(
                            errorMessage: "Your cart is empty",
                          ),
                        );
                      }
                    },
                    selectedPriceType: requestsProv[index]
                        .getPriceBySubscriptionType(subscriptionType),
                    course: requestsProv[index],
                    textTh: textTh,
                  ),
              const SizedBox(height: 20),
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

                          subscriptionController.updateSubscriptionType(
                              SubscriptionType.oneMonth);
                        },
                        duration: 1,
                      ),
                      SubscriptionWidget(
                        isActive:
                            subscriptionType == SubscriptionType.threeMonths,
                        onPress: () {
                          subscriptionController.updateSubscriptionType(
                              SubscriptionType.threeMonths);
                          setState(() {
                            subscriptionType = SubscriptionType.threeMonths;
                          });
                        },
                        duration: 3,
                      ),
                      SubscriptionWidget(
                        isActive:
                            subscriptionType == SubscriptionType.sixMonths,
                        onPress: () {
                          subscriptionController.updateSubscriptionType(
                              SubscriptionType.sixMonths);
                          setState(() {
                            subscriptionType = SubscriptionType.sixMonths;
                          });
                        },
                        duration: 6,
                      ),
                      SubscriptionWidget(
                        isActive: subscriptionType == SubscriptionType.yearly,
                        onPress: () {
                          subscriptionController
                              .updateSubscriptionType(SubscriptionType.yearly);
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
                    width: size.width * 0.8,
                    child: Column(
                      spacing: 5,
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
                        TextField(
                          controller: _transactionIdController,
                          decoration: InputDecoration(
                            labelText: 'Enter Transaction ID',
                            errorText:
                                _errorMessageTransactionId, // Show error message
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 2,
                                color: AppColors.mainBlue,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          onChanged: (value) {
                            // Validate on change
                            _validateInput();
                            if (_errorMessageTransactionId == null) {
                              // if error message is null then _transactionIdController.text will not
                              // be null or empty.
                              subscriptionController.updateTransactionId(
                                  _transactionIdController.text);
                            }
                          },
                        ),
                        const SizedBox(height: 5),
                        GestureDetector(
                          onTap: () async {
                            bool success = await pickTransactionImage();

                            if (success) {
                              subscriptionController.updateScreenshotPath(
                                  transactionImage?.path ?? "");
                              setState(() {
                                imagePicked = true;
                              });
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.mainBlue.withAlpha(100),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            height: 40,
                            width: size.width * 0.6,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Choose Image",
                                  style: TextStyle(
                                    color: _errorMessageImagePath != null
                                        ? Colors.red
                                        : Colors.black,
                                  ),
                                ),
                                const Icon(
                                  Icons.image,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (imagePicked &&
                            transactionImage != null &&
                            _errorMessageImagePath == null)
                          Image.file(
                            File(transactionImage!.path),
                            width: 60,
                            height: 60,
                          )
                        else if (_errorMessageImagePath != null)
                          Text(
                            _errorMessageImagePath!,
                            style:
                                textTh.labelMedium!.copyWith(color: Colors.red),
                          ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mainBlue,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 7,
                            ),
                            fixedSize: Size(size.width * 0.6, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            _validateInput(); // Validate when button is pressed
                            await _validateImagePath();
                            if (_errorMessageTransactionId != null ||
                                _errorMessageImagePath != null) {
                              return;
                            } else if (_errorMessageTransactionId == null &&
                                _errorMessageImagePath == null) {
                              final result =
                                  await subscriptionController.subscribe();
                              debugPrint(
                                  "api response: ApiResponse{ status: ${result.responseStatus}, message: ${result.message}}");
                              if (result.responseStatus) {
                                ref
                                    .read(courseRequestsProvider.notifier)
                                    .removeAll();
                                resetImagePicked();
                                _transactionIdController.clear();
                                await ref
                                    .refresh(homeScreenApiProvider.notifier)
                                    .fetchHomeScreenData();
                                await ref
                                    .refresh(paidCoursesApiProvider.notifier)
                                    .fetchPaidCourses();
                                // we need this so that next time home page fetches
                                // courses that are not bought.
                              }
                              if (context.mounted) {
                                ScaffoldMessenger.of(context)
                                    .removeCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(
                                      result.message,
                                      style: TextStyle(
                                        color: result.responseStatus
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          child: subscriptionProv.apiState == ApiState.busy
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : subscriptionProv.apiState == ApiState.idle
                                  ? Text(
                                      'Submit',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: size.width * 0.04,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  : Text(
                                      'Retry',
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
      ),
    );
  }

  Future<bool> pickTransactionImage() async {
    final XFile? image = await showImagePickSheet();
    if (image != null) {
      transactionImage = XFile(image.path);
      setState(() {
        _errorMessageImagePath = null;
      });
      return true;
    }
    return false;
  }

  void resetImagePicked() {
    setState(() {
      imagePicked = false;
      transactionImage = null;
    });
  }

  Future<XFile?> showImagePickSheet() async {
    final picker = ImagePicker();
    return await showModalBottomSheet<XFile?>(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          height: 150,
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
                  try {
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.camera);
                    if (image != null && context.mounted) {
                      Navigator.pop(context, image);
                    }
                  } catch (e) {
                    setState(() {
                      _errorMessageImagePath = e.toString();
                    });
                  }
                },
                child: const SizedBox(
                  height: 80,
                  width: 120,
                  child: Column(
                    children: [
                      Icon(Icons.camera),
                      Text("From Camera"),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  try {
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (image != null && context.mounted) {
                      Navigator.pop(context, image);
                    }
                  } catch (e) {
                    setState(() {
                      _errorMessageImagePath = e.toString();
                    });
                  }
                },
                child: const SizedBox(
                  height: 80,
                  width: 120,
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

  Future<void> _validateImagePath() async {
    if (!imagePicked) {
      setState(() {
        transactionImage == null;
        _errorMessageImagePath = "This field cannot be empty";
      });
    } else if (transactionImage != null) {
      var file = File(transactionImage!.path);
      int bytes = await file.length();
      if (bytes > 5 * 1024 * 1024) {
        setState(() {
          transactionImage == null;
          _errorMessageImagePath =
              "File size too big. It should be less than 5 Mb";
        });
      } else {
        setState(() {
          _errorMessageImagePath = null;
        });
      }
    } else {
      setState(() {
        _errorMessageImagePath = null;
      });
    }
  }

  void _validateInput() {
    setState(() {
      // Example validation: Check if the input is empty
      if (_transactionIdController.text.isEmpty) {
        _errorMessageTransactionId = 'This field cannot be empty';
      } else {
        _errorMessageTransactionId = null; // Clear error message if valid
      }
    });
  }
}
