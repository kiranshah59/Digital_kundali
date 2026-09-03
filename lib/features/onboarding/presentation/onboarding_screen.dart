import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingScreen extends StatelessWidget {
  final VoidCallback onNext;
  const OnboardingScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFAF9F5),
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        children: [
          SizedBox(height: 110.h),
          Container(
            width: 280.w,
            height: 280.h,
            decoration: BoxDecoration(
              color: const Color(0xFFFAF9F5),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFEAE6DF)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              'assets/images/onboarding.svg',
              width: 220.w,
              height: 220.h,
            ),
          ),
          SizedBox(height: 40.h),
          Text(
            'Astronomical Precision',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 26.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xFF11141A),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Powered by our own planetary engine using\nreal orbital mechanics for unmatched\naccuracy.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.sp,
              height: 1.6,
              color: Color(0xFF6B6B6B),
            ),
          ),
          const Spacer(),
          SizedBox(height: 140.h),
        ],
      ),
    );
  }
}
