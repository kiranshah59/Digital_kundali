import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.hasClients) {
        final int newIndex = _pageController.page?.round() ?? 0;
        if (newIndex != _currentIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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

  void _skipToLastPage() {
    _pageController.animateToPage(
      3,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            children: [
              SplashScreen(onNext: _goToNext),
              OnboardingScreen(onNext: _goToNext),
              OnboardingInsightsScreen(onNext: _goToNext),
              OnboardingClarityScreen(onNext: _finishOnboarding),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double page = 0.0;
                  if (_pageController.hasClients) {
                    page = _pageController.page ?? 0.0;
                  }
                  // Fade in as we swipe from Splash (page 0) to Onboarding (page 1)
                  double opacity = page.clamp(0.0, 1.0);
                  
                  return IgnorePointer(
                    ignoring: page < 0.5,
                    child: Opacity(
                      opacity: opacity,
                      child: child,
                    ),
                  );
                },
                child: _buildBottomControls(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) => _buildDot(index)),
          ),
          SizedBox(height: 32.h),

          // Button
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: SizedBox(
              key: ValueKey('btn_$_currentIndex'),
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: _currentIndex == 3 ? _finishOnboarding : _goToNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A0A0C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                child: _currentIndex <= 1
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'NEXT',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Icon(Icons.arrow_forward, size: 16.sp),
                        ],
                      )
                    : Text(
                        _currentIndex == 2 ? 'Get Started' : 'NEXT',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(height: 5.h),

          // Skip text
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _currentIndex <= 3
                ? TextButton(
                    key: const ValueKey('skip_btn'),
                    onPressed: _skipToLastPage,
                    child: Text(
                      'SKIP',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        color: const Color(0xFF6B6B6B),
                      ),
                    ),
                  )
                : SizedBox(height: 48.h, key: const ValueKey('empty_skip')),
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    bool isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        width: isActive ? 24.w : 8.w,
        height: 8.h,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFA88143) : const Color(0xFFD6D6D6),
          borderRadius: BorderRadius.circular(4.r),
        ),
      ),
    );
  }
}
