import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../profile/bloc/profile_bloc.dart';
import '../../profile/bloc/profile_event.dart';
import '../../profile/bloc/profile_state.dart';
import '../../auth/data/auth_service.dart';
import '../../auth/presentation/login_screen.dart';
import '../../kundali/bloc/kundali_bloc.dart';
import '../../kundali/bloc/kundali_event.dart';
import '../../kundali/bloc/kundali_state.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../../../widgets/birth_profiles_section.dart';
import '../../../widgets/transit_status_section.dart';
import '../../../widgets/daily_guidance_card.dart';
import '../../../widgets/life_area_forecast_grid.dart';
import '../../../widgets/ask_guru_banner.dart';
import '../../../widgets/upgrade_to_paid_banner.dart';
import '../../kundali/presentation/insight_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String? userName;

  const DashboardScreen({super.key, this.userName});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<dynamic> _cachedProfiles = [];

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfiles());
    
    final kundaliState = context.read<KundaliBloc>().state;
    if (kundaliState is KundaliLoaded) {
      final moonPlanet = kundaliState.chartData.chartData.planets['moon'];
      if (moonPlanet != null) {
        final moonSign = moonPlanet.sign.toLowerCase();
        context.read<DashboardBloc>().add(LoadDashboardData(rashiSlug: moonSign));
        return;
      }
    }
    context.read<DashboardBloc>().add(const LoadDashboardData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F5),
      body: SafeArea(
        child: BlocListener<KundaliBloc, KundaliState>(
          listener: (context, state) {
            if (state is KundaliLoaded) {
              final moonPlanet = state.chartData.chartData.planets['moon'];
              if (moonPlanet != null) {
                final moonSign = moonPlanet.sign.toLowerCase();
                context.read<DashboardBloc>().add(LoadDashboardData(rashiSlug: moonSign));
              }
            }
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
            _buildAppBar(),
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      bool isLoading = state is ProfileLoading || state is ProfileInitial;
                      
                      if (state is ProfileLoaded) {
                        _cachedProfiles = state.profiles;
                        // Fetch the chart for the first profile to use its planets for Transit Status
                        if (_cachedProfiles.isNotEmpty) {
                          final kundaliState = context.read<KundaliBloc>().state;
                          if (kundaliState is KundaliInitial || kundaliState is KundaliError) {
                            context.read<KundaliBloc>().add(LoadKundaliData(profileData: _cachedProfiles.first));
                          }
                        }
                      }
                      
                      return BirthProfilesSection(
                        profiles: _cachedProfiles,
                        isLoading: isLoading && _cachedProfiles.isEmpty,
                        onRefresh: () async {
                          context.read<ProfileBloc>().add(LoadProfiles());
                        },
                      );
                    },
                  ),
                  SizedBox(height: 32.h),
                  const TransitStatusSection(),
                
                  SizedBox(height: 32.h),
                  const DailyGuidanceCard(),
                  SizedBox(height: 32.h),
                  LifeAreaForecastGrid(
                    onTopicTap: (slug, title) {
                      final defaultProfile = _cachedProfiles.isNotEmpty ? _cachedProfiles.first : null;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InsightDetailScreen(
                            profileData: defaultProfile,
                            topicTitle: title,
                            topicSlug: slug,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 32.h),
                  const AskGuruBanner(),
                  SizedBox(height: 16.h),
                  const UpgradeToPaidBanner(),
                  SizedBox(height: 48.h),
                ]),
              ),
            ),
          ],
        ),
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
          Icon(Icons.star, color: const Color(0xFFA88143), size: 20.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              widget.userName != null ? 'Welcome, ${widget.userName}' : 'Digital Kundali',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF11141A),
              ),
              overflow: TextOverflow.ellipsis,
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
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  backgroundColor: const Color(0xFF424242),
                  title: const Text(
                    'Log out',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  content: const Text(
                    'Are you sure you want to log out?',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: const Text(
                        'CANCEL',
                        style: TextStyle(
                          color: Color(0xFF80CBC4),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.of(dialogContext).pop(); // Close dialog
                        context.read<ProfileBloc>().add(ClearProfiles());
                        await AuthService.logout();
                        if (context.mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      child: const Text(
                        'LOG OUT',
                        style: TextStyle(
                          color: Color(0xFF80CBC4),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          icon: Icon(
            Icons.logout,
            color: const Color(0xFF11141A),
            size: 24.sp,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 24.w, left: 8.w),
          child: CircleAvatar(
            radius: 16.r,
            backgroundColor: const Color(0xFFEAE6DF),
            child: Icon(Icons.person, size: 20.sp, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
