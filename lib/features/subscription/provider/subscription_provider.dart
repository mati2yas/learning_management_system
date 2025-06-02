// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:lms_system/features/requests/presentation/screens/requests_screen.dart';
// import 'package:lms_system/features/shared/model/api_response_model.dart';
// import 'package:lms_system/features/shared/model/shared_course_model.dart';
// import 'package:lms_system/features/subscription/repository/subscription_repository.dart';

// final subscriptionControllerProvider =
//     StateNotifierProvider<SubscriptionController, SubscriptionModel>((ref) {
//   return SubscriptionController(ref.watch(subscriptionRepositoryProvider));
// });

// class SubscriptionController extends StateNotifier<SubscriptionModel> {
//   final SubscriptionRepository _repository;
//   SubscriptionController(this._repository) : super(SubscriptionModel());

//   Future<ApiResponse> subscribe() async {
//     String statusMsg = "";
//     bool statusBool = false;
//     Response? response;
//     try {
//       state = state.copyWith(apiStatus: ApiStatus.busy);

//       response = await _repository.subscribe(state);
//       debugPrint(response.data["message"]);

//       state = state.copyWith(
//         statusMsg: response.data["message"] ?? "An Error Occurred.",
//         statusSuccess: response.data["status"] ?? false,
//       );
//       if (response.statusCode == 201) {
//         //debugPrint("status 201 case");
//         state = state.copyWith(
//           statusMsg: response.data["message"],
//           statusSuccess: response.data["status"],
//           apiStatus: ApiStatus.idle,
//         );
//       } else if (response.statusCode == 400) {
//         //debugPrint("status 400 case");
//         state = state.copyWith(
//           statusMsg: response.data["message"],
//           statusSuccess: response.data["status"],
//           apiStatus: ApiStatus.error,
//         );
//       }
//     } catch (e) {
//       //debugPrint("exception case");

//       state = state.copyWith(
//         statusMsg: e.toString().replaceAll("Exception:", ""),
//         statusSuccess: response?.data["status"] ?? false,
//         apiStatus: ApiStatus.error,
//       );
//     }
//     return ApiResponse(
//         message: state.statusMessage, responseStatus: state.statusSuccess);
//   }

//   void updateCourses(List<Course> newCourses) {
//     for (var c in newCourses) {
//       //debugPrint("in updateCourse, course id: ${c.id}");
//     }
//     state = state.copyWith(newCourses: newCourses);
//   }

//   void updateScreenshotPath(String imagePath) {
//     state = state.copyWith(newImagePath: imagePath);
//   }

//   void updateSubscriptionType(SubscriptionType newType) {
//     state = state.copyWith(newType: newType);
//   }

//   void updateTransactionId(String newTransactionId) {
//     state = state.copyWith(newTransactionId: newTransactionId);
//   }
// }
