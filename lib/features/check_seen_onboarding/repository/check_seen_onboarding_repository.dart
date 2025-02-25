import 'package:lms_system/features/check_seen_onboarding/data_source/check_seen_onboarding_data_source.dart';

class CheckSeenOnboardingRepository {
  final CheckSeenOnboardingDataSource _dataSource;
  CheckSeenOnboardingRepository(this._dataSource);

  Future<void> clearHasSeenOnboarding() {
    return _dataSource.clearSeenOnboardingStatus();
  }

  Future<bool> hasUserSeenOnboarding() {
    return _dataSource.hasSeenOnboarding();
  }

  Future<void> setHasSeeOnboardingAlready() async {
    await _dataSource.setHasSeenStatusAlready();
  }
}
