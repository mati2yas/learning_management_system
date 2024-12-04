import 'package:flutter/material.dart';
import 'package:lms_system/core/constants/colors.dart';

import '../../../../core/app_router.dart';
import '../widgets/current_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: const [
              CurrentPage(
                image: 'assets/svgs/onboarding_page1.svg',
                description:
                    'Join our community and connect with others Knowledge.',
              ),
              CurrentPage(
                image: 'assets/svgs/onboarding_page2.svg',
                description:
                    'Join our community and connect with others Knowledge.',
              ),
              CurrentPage(
                image: 'assets/svgs/onboarding_page3.svg',
                description:
                    'Join our community and connect with others Knowledge.',
              ),
            ],
          ),
          // Page indicator
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      if (_currentPage < 2) {
                        setState(() {
                          _currentPage = 2;
                          _pageController.jumpToPage(2);
                        });
                      } else {
                        Navigator.of(context)
                            .pushReplacementNamed(Routes.signup);
                      }
                    },
                    child: Text(
                      "Skip",
                      style: TextStyle(
                        color: _currentPage == 2
                            ? AppColors.mainBlue
                            : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const Spacer(),
                  // the three dots
                  ...List.generate(3, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      height: _currentPage == index ? 25 : 18,
                      width: _currentPage == index ? 10 : 8,
                      decoration: BoxDecoration(
                        color: AppColors.mainBlue,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  }),
                  const Spacer(),
                  if (_currentPage == 2)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CircleAvatar(
                        backgroundColor: AppColors.mainBlue,
                        child: IconButton(
                          color: Colors.white,
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed(Routes.signup);
                          },
                          icon: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CircleAvatar(
                        backgroundColor: AppColors.mainBlue,
                        child: IconButton(
                          color: Colors.white,
                          onPressed: () {
                            _currentPage = _currentPage + 1;
                            _pageController.jumpToPage(_currentPage);
                          },
                          icon: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
