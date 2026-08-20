import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DailyGuidanceCard extends StatelessWidget {
  const DailyGuidanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Subtle glow effect in the top right (mocked with a faint gradient circle)
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFA88143).withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                  stops: const [0.2, 1.0],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Daily Guidance',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF11141A),
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3EFE7),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      'MOON IN SCORPIO',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFA88143),
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'September 24, 2024',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF8A8A8A),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Text(
                '"The celestial alignments today suggest a deep introspection. As Mars influences your house of expression, maintain clarity in communication. A hidden opportunity in professional circles may reveal itself before sunset."',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontStyle: FontStyle.italic,
                  fontSize: 13.sp,
                  color: const Color(0xFF4A4A4A),
                  height: 1.6,
                ),
              ),
              SizedBox(height: 24.h),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0A0C),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'View Full Mahadasha',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
