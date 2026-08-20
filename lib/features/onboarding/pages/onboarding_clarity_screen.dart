import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/geometric_illustration_painter.dart';

class OnboardingClarityScreen extends StatelessWidget {
  final VoidCallback onNext;
  const OnboardingClarityScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFAF9F5),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      SizedBox(height: 50.h),
                      SizedBox(
                        width: 350.w,
                        height: 350.h,
                        child: CustomPaint(
                          painter: GeometricIllustrationPainter(),
                        ),
                      ),
                      SizedBox(height: 40.h),
                      _buildInfoCard(
                        true,
                        'CAREER PATH',
                        'You are naturally drawn to leadership roles requiring deep analytical focus and strategic planning.',
                      ),
                      SizedBox(height: 12.h),
                      _buildInfoCard(
                        true,
                        'PERSONAL GROWTH',
                        'The current planetary shift suggests a period of internal reflection and creative renewal.',
                      ),
                      SizedBox(height: 50.h),
                      Text(
                        'Read with Clarity',
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF11141A),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'No mystical jargon. Just plain English\nreadings grounded in your actual chart\ndata.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.sp,
                          height: 1.6,
                          color: Color(0xFF6B6B6B),
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDot(false),
                      _buildDot(false),
                      _buildDot(false),
                      _buildDot(true),
                    ],
                  ),
                  SizedBox(height: 32.h),
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
                      child: Text(
                        'NEXT',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(bool isGold, String label, String text) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFEAE6DF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: isGold
                      ? const Color(0xFFA88143)
                      : const Color(0xFFB0B0B0),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: isGold
                      ? const Color(0xFFA88143)
                      : const Color(0xFF8A8A8A),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.sp,
              height: 1.5,
              color: Color(0xFF4A4A4A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      width: isActive ? 24.w : 8.w,
      height: 8.h,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFA88143) : const Color(0xFFD6D6D6),
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }
}
