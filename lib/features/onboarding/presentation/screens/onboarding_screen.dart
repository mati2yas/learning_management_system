import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/features/check_seen_onboarding/provider/check_seen_onboarding_provider.dart';
import 'package:lms_system/features/shared/provider/start_routes_provider.dart';

import '../../data_source/onboarding_data_source.dart';
import '../../provider/onboarding_provider.dart';
import '../../repository/onboarding_repository.dart';
import '../widgets/current_page.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(onboardingProvider);
    final onboardingController = ref.read(onboardingProvider.notifier);
    final repository = OnboardingRepository(OnboardingDataSource());
    final onboardingPages = repository.getOnboardingPages();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () {
              if (currentPage < 2) {
                onboardingController.skipToLastPage();
              } else {
                Navigator.of(context).pushReplacementNamed(Routes.signup);
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
                      onPressed: () {
                        if (currentPage == onboardingPages.length - 2) {
                          ref
                              .read(checkSeenOnboardingControllerProvider
                                  .notifier)
                              .setHasSeenOnboardingAlready();
                        }
                        if (currentPage == onboardingPages.length - 1) {
                          final initialRouteProv =
                              ref.watch(startRoutesProvider);
                          String nextRoute = initialRouteProv.secondRoute;

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
}
