import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/storage_service.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) => SecureStorageService());
final onboardingStatusProvider =
    StateNotifierProvider<OnboardingStatusNotifier, bool>((ref) {
  final storageService = ref.watch(secureStorageServiceProvider);
  return OnboardingStatusNotifier(storageService);
});

class OnboardingStatusNotifier extends StateNotifier<bool> {
  final SecureStorageService _storageService;

  OnboardingStatusNotifier(this._storageService) : super(false);

  Future<void> checkOnboardingStatus() async {
    final hasSeenOnboarding = await _storageService.getOnboardingStatus();
    state = hasSeenOnboarding;
  }

  Future<void> setOnboardingStatus(bool status) async {
    await _storageService.setOnboardingStatus(status);
    state = status;
  }
}
