import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/check_seen_onboarding/data_source/check_seen_onboarding_data_source.dart';

import '../repository/check_seen_onboarding_repository.dart';

final checkSeenOnboardingDataSourceProvider = Provider(
  (ref) => CheckSeenOnboardingDataSource(),
);

final checkSeenOnboardingRepositoryProvider = Provider((ref) {
  final dataSource = ref.watch(checkSeenOnboardingDataSourceProvider);
  return CheckSeenOnboardingRepository(dataSource);
});
