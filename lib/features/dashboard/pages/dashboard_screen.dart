import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/birth_profiles_section.dart';
import '../widgets/transit_status_section.dart';
import '../widgets/daily_guidance_card.dart';
import '../widgets/life_area_forecast_grid.dart';
import '../widgets/ask_guru_banner.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F5),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(),
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const BirthProfilesSection(),
                  SizedBox(height: 32.h),
                  const TransitStatusSection(),
                  SizedBox(height: 32.h),
                  const DailyGuidanceCard(),
                  SizedBox(height: 32.h),
                  const LifeAreaForecastGrid(),
                  SizedBox(height: 32.h),
                  const AskGuruBanner(),
                  SizedBox(height: 48.h),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      backgroundColor: const Color(0xFFFAF9F5),
      elevation: 0,
      pinned: true,
      titleSpacing: 24.w,
      title: Row(
        children: [
          Icon(
            Icons.star,
            color: const Color(0xFFA88143),
            size: 20.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            'Digital Kundali',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF11141A),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.settings_outlined,
            color: const Color(0xFF11141A),
            size: 24.sp,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 24.w, left: 8.w),
          child: CircleAvatar(
            radius: 16.r,
            backgroundColor: const Color(0xFFEAE6DF),
            child: Icon(
              Icons.person,
              size: 20.sp,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
