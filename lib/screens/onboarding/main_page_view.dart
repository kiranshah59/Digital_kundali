import 'package:flutter/material.dart';

import '../splash/splash_screen.dart';
import 'onboarding_screen.dart';
import 'onboarding_insights_screen.dart';
import 'onboarding_clarity_screen.dart';
import '../authentication/sign_up_screen.dart';

class MainPageView extends StatefulWidget {
  const MainPageView({super.key});

  @override
  State<MainPageView> createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView> {
  final PageController _pageController = PageController();

  void _goToNext() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _finishOnboarding() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        children: [
          SplashScreen(onNext: _goToNext),
          OnboardingScreen(onNext: _goToNext),
          OnboardingInsightsScreen(onNext: _goToNext),
          OnboardingClarityScreen(onNext: _finishOnboarding),
        ],
      ),
    );
  }
}
