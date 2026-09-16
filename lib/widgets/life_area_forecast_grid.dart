import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/home/bloc/dashboard_bloc.dart';
import '../features/home/bloc/dashboard_state.dart';

class LifeAreaForecastGrid extends StatelessWidget {
  final void Function(String, String)? onTopicTap;

  const LifeAreaForecastGrid({super.key, this.onTopicTap});

  IconData _getIconForSlug(String slug) {
    switch (slug) {
      case 'career': return Icons.work_outline_rounded;
      case 'health': return Icons.spa_outlined;
      case 'wealth': return Icons.account_balance_outlined;
      case 'love': return Icons.favorite_border_rounded;
      case 'marriage': return Icons.favorite_outline;
      case 'education': return Icons.school_outlined;
      case 'business': return Icons.business_center_outlined;
      case 'general-nature': return Icons.person_outline;
      case 'physical-traits': return Icons.accessibility_new_outlined;
      case 'child': return Icons.child_care_outlined;
      case 'social': return Icons.people_outline;
      default: return Icons.auto_awesome_outlined;
    }
  }

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
          child: BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoaded) {
                final topics = state.insightTopics;
                if (topics.isEmpty) {
                  return const Center(child: Text('No forecast topics available'));
                }
                
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.h,
                  crossAxisSpacing: 16.w,
                  childAspectRatio: 0.9,
                  children: topics.map((topic) {
                    final slug = topic['slug'] ?? 'general';
                    return _buildForecastCard(
                      title: topic['name'] ?? 'Topic',
                      slug: slug,
                      icon: _getIconForSlug(slug),
                      statusText: 'INSIGHT',
                      statusColor: const Color(0xFF379D73),
                      statusBgColor: const Color(0xFFE8F4EE),
                      description: topic['description'] ?? 'Explore your forecast for this area.',
                    );
                  }).toList(),
                );
              } else if (state is DashboardLoading) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFFA88143)));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildForecastCard({
    required String title,
    required String slug,
    required IconData icon,
    required String statusText,
    required Color statusColor,
    required Color statusBgColor,
    required String description,
  }) {
    return GestureDetector(
      onTap: () {
        if (onTopicTap != null) {
          onTopicTap!(slug, title);
        }
      },
      child: Container(
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
      ),
    );
  }
}
