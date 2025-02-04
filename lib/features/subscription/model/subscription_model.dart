import 'package:dio/dio.dart';
import 'package:lms_system/features/requests/presentation/screens/requests_screen.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';

class SubscriptionModel {
  final List<Course> courses;
  final SubscriptionType subscriptionType;
  final String screenshotPath;
  final String transactionId;

  SubscriptionModel({
    this.courses = const [],
    this.subscriptionType = SubscriptionType.oneMonth,
    this.screenshotPath = "",
    this.transactionId = "",
  });
  SubscriptionModel copyWith({
    List<Course>? newCourses,
    SubscriptionType? newType,
    String? newImagePath,
    String? newTransactionId,
  }) {
    return SubscriptionModel(
      courses: newCourses ?? courses,
      subscriptionType: newType ?? subscriptionType,
      screenshotPath: newImagePath ?? screenshotPath,
      transactionId: newTransactionId ?? transactionId,
    );
  }

  Future<FormData> toFormData() async {
    return FormData.fromMap({
      "courses": courses.map((c) => int.parse(c.id)).toList(),
      "subscription_type": subscriptionType.name,
      "screenshot": await MultipartFile.fromFile(screenshotPath,
          filename: "screenshot.jpg"),
      "transaction_id": transactionId,
    });
  }
}
