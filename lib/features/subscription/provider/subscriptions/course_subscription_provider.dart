import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/features/shared/model/api_response_model.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';
import 'package:lms_system/features/subscription/repository/course_subscription_repository.dart';

import '../../model/course_subscription_model.dart';

final courseSubscriptionControllerProvider =
    StateNotifierProvider<SubscriptionController, CourseSubscriptionModel>((ref) {
  ProviderListenable<dynamic> subscriptionRepositoryProvider;
  return SubscriptionController(ref.watch(courseSubscriptionRepositoryProvider));
});

class SubscriptionController extends StateNotifier<CourseSubscriptionModel> {
  final CourseSubscriptionRepository _repository;
  SubscriptionController(this._repository) : super(CourseSubscriptionModel());

  Future<ApiResponse> subscribe() async {
    String statusMsg = "";
    bool statusBool = false;
    Response? response;
    try {
      state = state.copyWith(apiState: ApiState.busy);

      response = await _repository.subscribe(state);
      debugPrint(response.data["message"]);

      state = state.copyWith(
        statusMsg: response.data["message"] ?? "An Error Occurred.",
        statusSuccess: response.data["status"] ?? false,
      );
      if (response.statusCode == 201) {
        debugPrint("status 201 case");
        state = state.copyWith(
          statusMsg: response.data["message"],
          statusSuccess: response.data["status"],
          apiState: ApiState.idle,
        );
      } else if (response.statusCode == 400) {
        debugPrint("status 400 case");
        state = state.copyWith(
          statusMsg: response.data["message"],
          statusSuccess: response.data["status"],
          apiState: ApiState.error,
        );
      }
    } catch (e) {
      debugPrint("exception case");

      state = state.copyWith(
        statusMsg: e.toString().replaceAll("Exception:", ""),
        statusSuccess: response?.data["status"] ?? false,
        apiState: ApiState.error,
      );
    }
    return ApiResponse(
        message: state.statusMessage, responseStatus: state.statusSuccess);
  }

  void updateCourses(List<Course> newCourses) {
    for (var c in newCourses) {
      debugPrint("in updateCourse, course id: ${c.id}");
    }
    state = state.copyWith(newCourses: newCourses);
  }

  void updateScreenshotPath(String imagePath) {
    state = state.copyWith(newImagePath: imagePath);
  }

  void updateSubscriptionType(SubscriptionType newType) {
    state = state.copyWith(newType: newType);
  }

  void updateTransactionId(String newTransactionId) {
    state = state.copyWith(newTransactionId: newTransactionId);
  }
}
