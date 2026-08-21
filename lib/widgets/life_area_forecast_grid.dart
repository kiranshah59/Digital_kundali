import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LifeAreaForecastGrid extends StatelessWidget {
  const LifeAreaForecastGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            'LIFE AREA FORECAST',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: const Color(0xFF8A8A8A),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16.h,
            crossAxisSpacing: 16.w,
            childAspectRatio: 0.9,
            children: [
              _buildForecastCard(
                title: 'Career',
                icon: Icons.work_outline_rounded,
                statusText: 'FAVORABLE',
                statusColor: const Color(0xFF379D73),
                statusBgColor: const Color(0xFFE8F4EE),
                description: 'Growth period starts. Mercury helps negotiation.',
              ),
              _buildForecastCard(
                title: 'Health',
                icon: Icons.spa_outlined,
                statusText: 'STABLE',
                statusColor: const Color(0xFFA88143),
                statusBgColor: const Color(0xFFF3EFE7),
                description: 'Energy levels consistent. Focus on sleep cycles.',
              ),
              _buildForecastCard(
                title: 'Wealth',
                icon: Icons.account_balance_outlined,
                statusText: 'CAUTION',
                statusColor: const Color(0xFFD35555),
                statusBgColor: const Color(0xFFFBEAEA),
                description: 'Avoid high-risk investments until Thursday.',
              ),
              _buildForecastCard(
                title: 'Love',
                icon: Icons.favorite_border_rounded,
                statusText: 'BRIGHT',
                statusColor: const Color(0xFF379D73),
                statusBgColor: const Color(0xFFE8F4EE),
                description: 'Harmonious Venus aspect. Socialize tonight.',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildForecastCard({
    required String title,
    required IconData icon,
    required String statusText,
    required Color statusColor,
    required Color statusBgColor,
    required String description,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFCF9),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFEAE6DF), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: const Color(0xFF11141A),
                size: 20.sp,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 7.sp,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF11141A),
            ),
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10.sp,
                color: const Color(0xFF8A8A8A),
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
