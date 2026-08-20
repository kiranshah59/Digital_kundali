import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingInsightsScreen extends StatelessWidget {
  final VoidCallback onNext;
  const OnboardingInsightsScreen({super.key, required this.onNext});

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24.h),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Color(0xFFA88143),
                            size: 16.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Digital Kundali',
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF11141A),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: Colors.white, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 30,
                              offset: const Offset(0, 20),
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 8),
                            ),
                            BoxShadow(
                              color: const Color(
                                0xFFA88143,
                              ).withValues(alpha: 0.05),
                              blurRadius: 40,
                              offset: const Offset(0, 25),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 16.r,
                                  backgroundColor: const Color(0xFFEAE6DF),
                                  child: Icon(
                                    Icons.person,
                                    size: 20.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Guru AI',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 4.w,
                                          height: 4.h,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFA88143),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          'LIFE ANALYSIS',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 8.sp,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 1,
                                            color: Color(0xFF8A8A8A),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.more_vert,
                                  color: Colors.grey,
                                  size: 20.sp,
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Container(
                              height: 1,
                              color: const Color(0xFFF0EFEA),
                            ),
                            SizedBox(height: 16.h),
                            Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F7F3),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                '"Based on your Saturn placement in the 10th house, this period calls for disciplined career expansion. Would you like to see how this impacts your current project?"',
                                style: TextStyle(
                                  fontFamily: 'Georgia',
                                  fontStyle: FontStyle.italic,
                                  fontSize: 13.sp,
                                  color: Color(0xFF4A4A4A),
                                  height: 1.5,
                                ),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0A0A0C),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Text(
                                  'Tell me more about career stability\nfor the next 6 months.',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F7F3),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 3.w,
                                        height: 3.h,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFA88143),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 3.w),
                                      Container(
                                        width: 3.w,
                                        height: 3.h,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFA88143),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 3.w),
                                      Container(
                                        width: 3.w,
                                        height: 3.h,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFA88143),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Calculating Mahadasha influences...',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 10.sp,
                                      color: Color(0xFF8A8A8A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F7F3),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Ask Guru about your career...',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12.sp,
                                      color: Color(0xFFB0B0B0),
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.send_rounded,
                                    size: 16.sp,
                                    color: Color(0xFF8A8A8A),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'PERSONAL GUIDANCE',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: Color(0xFFA88143),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Grounded Insights',
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF11141A),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Topic-specific interpretations for career, marriage, and family—unique to your journey. Our AI-enhanced Vedic analysis provides clarity where you need it most.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.sp,
                          height: 1.6,
                          color: Color(0xFF6B6B6B),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      _buildTopicCard(
                        Icons.work_outline,
                        'Career Path',
                        'Stability & Growth',
                      ),
                      SizedBox(height: 12.h),
                      _buildTopicCard(
                        Icons.favorite_border,
                        'Relationships',
                        'Marriage & Union',
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
                      _buildDot(true),
                      _buildDot(false),
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
                        'Get Started',
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

  Widget _buildTopicCard(IconData icon, String title, String subtitle) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F1EB),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFEAE6DF)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: const Color(0xFFEBE6DA),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: const Color(0xFFA88143), size: 18),
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                  color: Color(0xFF11141A),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11.sp,
                  color: Color(0xFF6B6B6B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      width: isActive ? 20.w : 6.w,
      height: 6.h,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFA88143) : const Color(0xFFD6D6D6),
        borderRadius: BorderRadius.circular(3.r),
      ),
    );
  }
}
