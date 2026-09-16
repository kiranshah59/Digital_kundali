import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../features/home/presentation/upgrade_to_paid_screen.dart';

class UpgradeToPaidBanner extends StatelessWidget {
  const UpgradeToPaidBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF9F5), // Background same as scaffold, or white
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: const Color(0xFFA88143), // Golden border
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.r),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UpgradeToPaidScreen(),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Upgrade to Paid',
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF11141A),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Unlock topic insights, Dasha & Dosha analysis, the Nepali kundali view, and more.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.sp,
                          color: const Color(0xFF4A4A4A),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Icon(
                  Icons.chevron_right,
                  color: const Color(0xFFA88143), // Gold arrow
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
