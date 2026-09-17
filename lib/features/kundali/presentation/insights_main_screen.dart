import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../profile/bloc/profile_bloc.dart';
import '../../profile/bloc/profile_state.dart';
import '../data/chart_service.dart';
import 'insight_detail_screen.dart';

class InsightsMainScreen extends StatefulWidget {
  const InsightsMainScreen({super.key});

  @override
  State<InsightsMainScreen> createState() => _InsightsMainScreenState();
}

class _InsightsMainScreenState extends State<InsightsMainScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<dynamic> _topics = [];

  @override
  void initState() {
    super.initState();
    _fetchTopics();
  }

  Future<void> _fetchTopics() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final response = await ChartService.getInsightTopics();
    if (mounted) {
      if (response['success'] == true) {
        setState(() {
          _topics = response['data'] ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response['message'] ?? 'Failed to load topics';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        if (profileState is ProfileLoading || profileState is ProfileInitial) {
          return const Scaffold(
            backgroundColor: Color(0xFFFAF9F5),
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFA88143)),
              ),
            ),
          );
        }

        String fullName = 'Unknown User';
        dynamic currentProfile;
        if (profileState is ProfileLoaded && profileState.profiles.isNotEmpty) {
          currentProfile = profileState.profiles.first;
          fullName = currentProfile['full_name'] ?? 'Unknown User';
        }

        return Scaffold(
          backgroundColor: const Color(0xFFFAF9F5),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (Navigator.canPop(context)) ...[
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: const Color(0xFF11141A),
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () => Navigator.pop(context),
                            ),
                            SizedBox(width: 16.w),
                          ],
                          Icon(
                            Icons.auto_awesome,
                            color: const Color(0xFFA88143),
                            size: 26.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Insights',
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 26.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF11141A),
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDFCF9),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: const Color(0xFFEAE6DF)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.person_outline_rounded,
                              size: 16.sp,
                              color: const Color(0xFFA88143),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              fullName,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF11141A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFFA88143),
                            ),
                          ),
                        )
                      : _errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: const Color(0xFFD35555),
                                size: 48.sp,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                _errorMessage!,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14.sp,
                                  color: const Color(0xFF11141A),
                                ),
                              ),
                              SizedBox(height: 24.h),
                              ElevatedButton(
                                onPressed: _fetchTopics,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFA88143),
                                ),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : _topics.isEmpty
                      ? Center(
                          child: Text(
                            'No insights found.',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14.sp,
                              color: const Color(0xFF5A5A5A),
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 8.h,
                          ),
                          physics: const BouncingScrollPhysics(),
                          itemCount: _topics.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 16.h),
                          itemBuilder: (context, index) {
                            final topic = _topics[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true).push(
                                  MaterialPageRoute(
                                    builder: (context) => InsightDetailScreen(
                                      profileData: currentProfile,
                                      topicTitle:
                                          topic['title'] ??
                                          topic['name'] ??
                                          'Insight',
                                      topicSlug: topic['slug'] ?? '',
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(20.w),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFAF9F5),
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                    color: const Color(0xFFEAE6DF),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            topic['title'] ??
                                                topic['name'] ??
                                                'Unknown Topic',
                                            style: TextStyle(
                                              fontFamily: 'Georgia',
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF11141A),
                                            ),
                                          ),
                                          SizedBox(height: 8.h),
                                          if (topic['description'] != null ||
                                              topic['desc'] != null)
                                            Text(
                                              topic['description'] ??
                                                  topic['desc'] ??
                                                  '',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 12.sp,
                                                height: 1.4,
                                                color: const Color(0xFF5A5A5A),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      color: const Color(0xFF11141A),
                                      size: 20.sp,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
