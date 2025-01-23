import '../model/onboarding_model.dart';

class OnboardingDataSource {
  List<OnboardingModel> getOnboardingPages() {
    return [
      OnboardingModel(
        imagePath: 'assets/svgs/onboarding_page1.svg',
        description: 'Join our community and connect with others Knowledge.',
      ),
      OnboardingModel(
        imagePath: 'assets/svgs/onboarding_page2.svg',
        description: 'Learn from the best experts in the field.',
      ),
      OnboardingModel(
        imagePath: 'assets/svgs/onboarding_page3.svg',
        description: 'Achieve your goals with tailored content.',
      ),
    ];
  }
}
