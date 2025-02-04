import 'package:dio/dio.dart';
import 'package:lms_system/features/requests/presentation/screens/requests_screen.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';

class SubscriptionModel {
  final List<Course> courses;
  final SubscriptionType subscriptionType;
  final String screenshotPath;
  final String transactionId;
  final String statusMessage;

  SubscriptionModel({
    this.courses = const [],
    this.subscriptionType = SubscriptionType.oneMonth,
    this.screenshotPath = "",
    this.transactionId = "",
    this.statusMessage = "",
  });
  SubscriptionModel copyWith({
    List<Course>? newCourses,
    SubscriptionType? newType,
    String? newImagePath,
    String? newTransactionId,
    String? statusMsg,
  }) {
    return SubscriptionModel(
      courses: newCourses ?? courses,
      subscriptionType: newType ?? subscriptionType,
      screenshotPath: newImagePath ?? screenshotPath,
      transactionId: newTransactionId ?? transactionId,
      statusMessage: statusMsg ?? statusMessage,
    );
  }

  Future<FormData> toFormData() async {
    FormData formData = FormData();

    // ✅ Append courses as multiple fields
    for (var courseId in courses) {
      formData.fields.add(MapEntry("courses[]", courseId.toString()));
    }

    // ✅ Append other fields
    formData.fields.add(MapEntry("subscription_type", subscriptionType.name));
    formData.fields.add(MapEntry("transaction_id", transactionId));

    // ✅ Append image as file
    formData.files.add(
      MapEntry(
        "screenshot",
        await MultipartFile.fromFile(
          screenshotPath,
          filename: "screenshot.jpg",
        ),
      ),
    );

    return formData;
  }

  // Future<FormData> toFormData() async {
  //   List<String> courseIds = [];
  //   for (var c in courses) {
  //     courseIds.add(c.id);
  //     debugPrint("current course id: ${c.id}");
  //   }
  //   debugPrint("Course IDs: $courseIds");
  //   return FormData.fromMap({
  //     "courses": courseIds,
  //     "subscription_type": subscriptionType.name,
  //     "screenshot": await MultipartFile.fromFile(screenshotPath,
  //         filename: "screenshot.jpg"),
  //     "transaction_id": transactionId,
  //   });
  // }
}
