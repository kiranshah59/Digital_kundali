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
          SizedBox(height: 80.h),
          Text(
            'DIGITAL KUNDALI',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 20.sp,
              letterSpacing: 3,
              fontWeight: FontWeight.w500,
              color: Color(0xFF11141A),
            ),
          ),
          SizedBox(height: 30.h),
          Container(
            width: 280.w,
            height: 280.h,
            decoration: BoxDecoration(
              color: const Color(0xFFFAF9F5),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFEAE6DF)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              'assets/onboarding.svg',
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
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              4,
              (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                width: 6.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: index == 0
                      ? const Color(0xFF947239)
                      : const Color(0xFFD6D6D6),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          SizedBox(height: 25.h),
          SizedBox(
            width: double.infinity,
            height: 56.h,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A0A0C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Row(
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
              ),
            ),
          ),
          SizedBox(height: 5.h),
          TextButton(
            onPressed: onNext,
            child: Text(
              'SKIP',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
                color: Color(0xFF6B6B6B),
              ),
            ),
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }
}
