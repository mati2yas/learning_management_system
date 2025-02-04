import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/requests/presentation/screens/requests_screen.dart';
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

  Future<void> subscribe() async {
    try {
      await _repository.subscribe(state);
    } catch (e) {
      rethrow;
    }
  }

  void updateCourses(List<Course> newCourses) {
    state = state.copyWith(newCourses: newCourses);
  }

  void updateScreenshotPath(String imagePath) {
    state = state.copyWith(newImagePath: imagePath);
  }

  void updateSubscriptionType(SubscriptionType newType) {
    state = state.copyWith(newType: newType);
  }
}
