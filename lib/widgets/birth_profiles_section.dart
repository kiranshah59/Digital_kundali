import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../screens/kundali/birth_chart_detail_screen.dart';
import '../screens/profile/add_profile_screen.dart';

class BirthProfilesSection extends StatelessWidget {
  final List<dynamic> profiles;
  final bool isLoading;
  final VoidCallback onRefresh;

  const BirthProfilesSection({
    super.key,
    required this.profiles,
    required this.isLoading,
    required this.onRefresh,
  });

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
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddProfileScreen(),
                    ),
                  );
                  if (result == true) {
                    onRefresh();
                  }
                },
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
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFFA88143)),
                  ),
                )
              : profiles.isEmpty
                  ? Center(
                      child: Text(
                        'No profiles added yet. Tap "Add New" to get started.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.sp,
                          color: const Color(0xFF8A8A8A),
                        ),
                      ),
                    )
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      physics: const BouncingScrollPhysics(),
                      itemCount: profiles.length,
                      separatorBuilder: (context, index) => SizedBox(width: 12.w),
                      itemBuilder: (context, index) {
                        final profile = profiles[index];
                        final isPrimary = profile['is_primary'] == true;
                        
                        // Fallback data if API fields are missing
                        final name = profile['full_name'] ?? 'Unknown User';
                        
                        return _buildProfileCard(
                          context: context,
                          isActive: isPrimary || index == 0, // Fallback to first if no primary
                          name: isPrimary ? '$name\n(You)' : name,
                          subtitle: 'Tap to view Chart',
                          icon: isPrimary ? Icons.wb_sunny_outlined : Icons.nightlight_round,
                          profile: profile,
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildProfileCard({
    required BuildContext context,
    required bool isActive,
    required String name,
    required String subtitle,
    required IconData icon,
    required dynamic profile,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BirthChartDetailScreen(profileData: profile),
          ),
        );
      },
      child: Container(
        width: 140.w,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFF3EFE7) : const Color(0xFFFDFCF9),
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
                    Expanded(
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10.sp,
                          color: const Color(0xFF8A8A8A),
                        ),
                        overflow: TextOverflow.ellipsis,
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
      ),
    );
  }
}
