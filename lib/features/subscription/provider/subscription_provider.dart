import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/requests/presentation/screens/requests_screen.dart';
import 'package:lms_system/features/shared/model/api_response_model.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';
import 'package:lms_system/features/subscription/model/subscription_model.dart';
import 'package:lms_system/features/subscription/repository/subscription_repository.dart';

final subscriptionControllerProvider =
    StateNotifierProvider<SubscriptionController, SubscriptionModel>((ref) {
  return SubscriptionController(ref.watch(subscriptionRepositoryProvider));
});

class SubscriptionController extends StateNotifier<SubscriptionModel> {
  final SubscriptionRepository _repository;
  SubscriptionController(this._repository) : super(SubscriptionModel());

  Future<ApiResponse> subscribe() async {
    String responseMessage = "";
    bool responseStatus = false;
    try {
      state = state.copyWith(apiStatus: ApiStatus.busy);

      final response = await _repository.subscribe(state);
      if (response.statusCode == 201) {
        state = state.copyWith(
            statusMsg: "Subscription successful", apiStatus: ApiStatus.idle);

        (responseMessage, responseStatus) =
            (response.data["message"], response.data["status"]);
        //return "success, ${response.data["data"]}";
      } else {
        state = state.copyWith(statusMsg: "Subscription failed");

        (responseMessage, responseStatus) =
            (response.data["message"], response.data["status"]);
        //return "error ${response.statusMessage}";
      }
    } catch (e) {
      state = state.copyWith(
          statusMsg: "An error occurred", apiStatus: ApiStatus.error);
      //return "error";

      (responseMessage, responseStatus) = (state.statusMessage, false);
    }
    return ApiResponse(
        message: responseMessage, responseStatus: responseStatus);
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
