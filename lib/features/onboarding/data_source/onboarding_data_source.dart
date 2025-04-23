import '../model/onboarding_model.dart';

class OnboardingDataSource {
  List<OnboardingModel> getOnboardingPages() {
    return [
      OnboardingModel(
        imagePath: 'assets/svgs/onboarding_page1.svg',
        description: 'Gain vast knowledge from our excellent courses',
      ),
      OnboardingModel(
        imagePath: 'assets/svgs/onboarding_page2.svg',
        description: 'Prepare For Exams With Our Large Collection of Exams',
      ),
      OnboardingModel(
        imagePath: 'assets/svgs/onboarding_page3.svg',
        description: 'Achieve Your Study Goals With Tailored Content.',
      ),
    ];
  }
}
