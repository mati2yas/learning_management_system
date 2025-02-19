import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/features/auth_status_registration/provider/reg_status_repository_provider.dart';
import 'package:lms_system/features/onboarding/provider/onboarding_status_provider.dart';

import '../../data_source/onboarding_data_source.dart';
import '../../provider/onboarding_provider.dart';
import '../../repository/onboarding_repository.dart';
import '../widgets/current_page.dart';

class OnboardingScreen extends HookConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(onboardingProvider);
    final onboardingController = ref.read(onboardingProvider.notifier);
    final repository = OnboardingRepository(OnboardingDataSource());
    final onboardingPages = repository.getOnboardingPages();
    final onboardingStatusController =
        ref.watch(onboardingStatusProvider.notifier);
    final registeredStatController =
        ref.watch(registrationStatusControllerProvider.notifier);
    // Check the onboarding status and navigate if needed
    useEffect(() {
      if (ref.watch(onboardingStatusProvider)) {
        checkOnboardingAndNavigate(ref);
      }
      return null;
    }, [ref.watch(onboardingStatusProvider)]);

    // If the user has not seen the onboarding screens, show them
    if (!ref.watch(onboardingStatusProvider)) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            TextButton(
              onPressed: () {
                if (currentPage < 2) {
                  onboardingController.skipToLastPage();
                } else {
                  Navigator.of(context).pushReplacementNamed('/signup');
                }
              },
              child: Text(
                "Skip",
                style: TextStyle(
                  color: currentPage == 2 ? Colors.blue : Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            PageView(
              controller: onboardingController.pageController,
              onPageChanged: onboardingController.setPage,
              children: onboardingPages
                  .map(
                    (page) => CurrentPage(
                      image: page.imagePath,
                      description: page.description,
                    ),
                  )
                  .toList(),
            ),
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  ...List.generate(
                    onboardingPages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      height: currentPage == index ? 25 : 18,
                      width: currentPage == index ? 10 : 8,
                      decoration: BoxDecoration(
                        color: AppColors.mainBlue,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: CircleAvatar(
                      backgroundColor: AppColors.mainBlue,
                      child: IconButton(
                        color: Colors.white,
                        onPressed: () async {
                          if (currentPage == onboardingPages.length - 1) {
                            final registered = await registeredStatController
                                .checkRegistrationStatus();

                            String nextRoute =
                                registered ? Routes.wrapper : Routes.signup;

                            if (context.mounted) {
                              Navigator.of(context)
                                  .pushReplacementNamed(nextRoute);
                            }
                          } else {
                            onboardingController.nextPage();
                          }
                        },
                        icon: const Icon(Icons.arrow_forward),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }

    // If the user has seen the onboarding screens, return an empty widget
    return const SizedBox.shrink();
  }

  Future<void> checkOnboardingAndNavigate(WidgetRef ref) async {
    final registeredStatController =
        ref.watch(registrationStatusControllerProvider.notifier);
    final registered = await registeredStatController.checkRegistrationStatus();
    final nextRoute = registered ? Routes.wrapper : Routes.signup;

    if (ref.context.mounted) {
      Navigator.of(ref.context).pushReplacementNamed(nextRoute);
    }
  }
}
