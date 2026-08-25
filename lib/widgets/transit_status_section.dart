import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransitStatusSection extends StatelessWidget {
  const TransitStatusSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            children: [
              Text(
                'TRANSIT STATUS',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: const Color(0xFF8A8A8A),
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 6.w,
                height: 6.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFD35555),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                'LIVE',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFD35555),
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 85.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            physics: const BouncingScrollPhysics(),
            children: [
              _buildTransitCard(
                planet: 'Mars (Mangal)',
                sign: 'Aries',
                degree: "10° 15'",
              ),
              SizedBox(width: 12.w),
              _buildTransitCard(
                planet: 'Venus (Shukra)',
                sign: 'Taurus',
                degree: "12° 20'",
              ),
              SizedBox(width: 12.w),
              _buildTransitCard(
                planet: 'Mercury (Budh)',
                sign: 'Gemini',
                degree: "05° 30'",
              ),
              SizedBox(width: 12.w),
              _buildTransitCard(
                planet: 'Moon (Chandra)',
                sign: 'Cancer',
                degree: "02° 45'",
              ),
              SizedBox(width: 12.w),
              _buildTransitCard(
                planet: 'Sun (Surya)',
                sign: 'Leo',
                degree: "14° 22'",
              ),
              SizedBox(width: 12.w),
              _buildTransitCard(
                planet: 'Mercury (Budh)',
                sign: 'Virgo',
                degree: "18° 10'",
              ),
              SizedBox(width: 12.w),
              _buildTransitCard(
                planet: 'Venus (Shukra)',
                sign: 'Libra',
                degree: "22° 05'",
              ),
              SizedBox(width: 12.w),
              _buildTransitCard(
                planet: 'Mars (Mangal)',
                sign: 'Scorpio',
                degree: "08° 40'",
              ),
              SizedBox(width: 12.w),
              _buildTransitCard(
                planet: 'Jupiter (Guru)',
                sign: 'Sagittarius',
                degree: "15° 50'",
              ),
              SizedBox(width: 12.w),
              _buildTransitCard(
                planet: 'Saturn (Shani)',
                sign: 'Capricorn',
                degree: "20° 11'",
              ),
              SizedBox(width: 12.w),
              _buildTransitCard(
                planet: 'Saturn (Shani)',
                sign: 'Aquarius',
                degree: "25° 10'",
              ),
              SizedBox(width: 12.w),
              _buildTransitCard(
                planet: 'Jupiter (Guru)',
                sign: 'Pisces',
                degree: "09° 05'",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransitCard({
    required String planet,
    required String sign,
    required String degree,
  }) {
    return Container(
      width: 110.w,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFCF9),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFEAE6DF), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            planet,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10.sp,
              color: const Color(0xFF8A8A8A),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            sign,
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF11141A),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            degree,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFA88143),
            ),
          ),
        ],
      ),
    );
  }
}
