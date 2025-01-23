import '../data_source/onboarding_data_source.dart';
import '../model/onboarding_model.dart';

class OnboardingRepository {
  final OnboardingDataSource dataSource;

  OnboardingRepository(this.dataSource);

  List<OnboardingModel> getOnboardingPages() {
    return dataSource.getOnboardingPages();
  }
}
