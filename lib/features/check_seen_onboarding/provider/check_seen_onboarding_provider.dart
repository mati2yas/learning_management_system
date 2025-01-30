import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/check_seen_onboarding/provider/check_seen_onboarding_controller.dart';
import 'package:lms_system/features/check_seen_onboarding/repository/check_seen_onboarding_repository.dart';

final checkSeenOnboardingControllerProvider =
    StateNotifierProvider<CheckSeenOnboardingController, bool>((ref) {
  final repository = ref.watch(checkSeenOnboardingRepositoryProvider);
  return CheckSeenOnboardingController(repository);
});

class CheckSeenOnboardingController extends StateNotifier<bool> {
  final CheckSeenOnboardingRepository _repository;
  CheckSeenOnboardingController(this._repository) : super(false);

  Future<bool> checkSeenOnboarding() async {
    await _repository.hasUserSeenOnboarding();
    return state;
  }

  Future<void> clearHasSeenOnboarding() async {
    await _repository.clearHasSeenOnboarding();
    state = false;
  }
}
