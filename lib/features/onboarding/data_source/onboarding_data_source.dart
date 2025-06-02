import '../model/onboarding_model.dart';

class OnboardingDataSource {
  List<OnboardingModel> getOnboardingPages() {
    return [
      OnboardingModel(
        imagePath: 'assets/svgs/onboarding_page1.svg',
        title: "Welcome to Excelet Academy — your all-in-one learning hub.",
        description:
            'From school subjects to real-world skills, we help you learn smarter, faster, and better.',
      ),
      OnboardingModel(
        imagePath: 'assets/svgs/onboarding_page2.svg',
        title:
            "Master any subject with expert-led lessons and engaging content.",
        description:
            "From elementary to university and beyond — explore a wide range of academic and professional courses, all in one place.",
      ),
      OnboardingModel(
        imagePath: 'assets/svgs/onboarding_page3.svg',
        title:
            "Ace your exams with real past papers and detailed explanations.",
        description:
            "Practice for ESSLCE, Exit Exam, UAT, NGAT, Standardized Tests,Grade 6 & 8 Ministry exams, and more — with filters for better access. Explanations come in text, image, or video formats.",
      ),
    ];
  }
}
