import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BirthProfilesSection extends StatelessWidget {
  const BirthProfilesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'BIRTH PROFILES',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: const Color(0xFF8A8A8A),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(
                      Icons.add_circle_outline_rounded,
                      color: const Color(0xFFA88143),
                      size: 14.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Add New',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFA88143),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 80.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            physics: const BouncingScrollPhysics(),
            children: [
              _buildProfileCard(
                isActive: true,
                name: 'Aries Native\n(You)',
                subtitle: 'Sun in Leo',
                icon: Icons.wb_sunny_outlined,
              ),
              SizedBox(width: 12.w),
              _buildProfileCard(
                isActive: false,
                name: 'Aditi',
                subtitle: 'Moon in Virgo',
                icon: Icons.nightlight_round,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard({
    required bool isActive,
    required String name,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      width: 140.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFF3EFE7) : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: isActive
            ? Border.all(color: const Color(0xFFA88143), width: 1.5)
            : Border.all(color: const Color(0xFFEAE6DF), width: 1),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF11141A),
                  height: 1.2,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(
                    icon,
                    size: 10.sp,
                    color: const Color(0xFF8A8A8A),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10.sp,
                      color: const Color(0xFF8A8A8A),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (isActive)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 6.w,
                height: 6.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFA88143),
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
