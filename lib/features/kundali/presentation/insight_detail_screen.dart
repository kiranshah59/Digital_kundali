import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'rashi_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/insight_bloc.dart';
import '../bloc/insight_event.dart';
import '../bloc/insight_state.dart';
import '../models/chart_model.dart';
import '../models/insight_model.dart';
import '../data/chart_service.dart';
import '../../../widgets/paid_plan_widget.dart';
import '../../home/presentation/upgrade_to_paid_screen.dart';

class InsightDetailScreen extends StatefulWidget {
  final dynamic profileData;
  final String topicTitle;
  final String topicSlug;

  const InsightDetailScreen({
    super.key, 
    required this.profileData, 
    required this.topicTitle, 
    required this.topicSlug,
  });

  @override
  State<InsightDetailScreen> createState() => _InsightDetailScreenState();
}

class _InsightDetailScreenState extends State<InsightDetailScreen> {
  bool _isDetailed = false;
  bool _showEnglish = true;
  int? _chartId;
  @override
  void initState() {
    super.initState();
    _fetchInsightData();
  }

  Future<void> _fetchInsightData() async {
    final String fullName = widget.profileData?['full_name'] ?? 'Unknown';
    final profileId = widget.profileData?['id'] ?? fullName.hashCode.abs();

    if (_chartId == null) {
      // Temporary fetch to get chartId
      final chartRes = await ChartService.getChart(profileId);
      if (chartRes['success']) {
        _chartId = (chartRes['data'] as ChartModel).id;
      } else {
        // If it doesn't exist yet, we must generate it because the insights API requires a valid chartId
        final genRes = await ChartService.generateChart(profileId);
        if (genRes['success']) {
          _chartId = (genRes['data'] as ChartModel).id;
        } else {
          _chartId = profileId; // fallback
        }
      }
    }

    String lang = _showEnglish ? 'en' : 'ne';
    String apiStyle = _isDetailed ? 'technical' : 'simple';

    context.read<InsightBloc>().add(
      LoadInsight(
        chartId: _chartId!,
        topicSlug: widget.topicSlug,
        language: lang,
        style: apiStyle,
      ),
    );
  }

  void _regenerateInsight() {
    if (_chartId == null) return;
    String lang = _showEnglish ? 'en' : 'ne';
    String apiStyle = _isDetailed ? 'technical' : 'simple';

    context.read<InsightBloc>().add(
      RegenerateInsight(
        chartId: _chartId!,
        topicSlug: widget.topicSlug,
        language: lang,
        style: apiStyle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String fullName = widget.profileData?['full_name'] ?? 'Unknown User';

    // Get initials
    final List<String> nameParts = fullName
        .split(' ')
        .where((p) => p.isNotEmpty)
        .toList();
    String initials = 'U';
    if (nameParts.isNotEmpty) {
      if (nameParts.length >= 2) {
        initials = '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
      } else {
        initials = nameParts[0].length >= 2
            ? nameParts[0].substring(0, 2).toUpperCase()
            : nameParts[0].toUpperCase();
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF9F5),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: const Color(0xFF11141A),
            size: 24.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.topicTitle,
          style: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF11141A),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),


            // Toggles Row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Simple / Detailed Toggle
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAE6DF),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Row(
                      children: [
                        _buildToggle('Simple', !_isDetailed, () {
                          setState(() => _isDetailed = false);
                          _fetchInsightData();
                        }),
                        _buildToggle('Detailed', _isDetailed, () {
                          setState(() => _isDetailed = true);
                          _fetchInsightData();
                        }),
                      ],
                    ),
                  ),
                  // EN / NE Toggle
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAE6DF),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Row(
                      children: [
                        _buildToggle('EN', _showEnglish, () {
                          setState(() => _showEnglish = true);
                          _fetchInsightData();
                        }),
                        _buildToggle('NE', !_showEnglish, () {
                          setState(() => _showEnglish = false);
                          _fetchInsightData();
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Main Health Card
            BlocConsumer<InsightBloc, InsightState>(
              listener: (context, state) {
                if (state is InsightError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                if (state is InsightLoading || state is InsightInitial) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.w),
                      child: CircularProgressIndicator(
                        color: const Color(0xFFA88143),
                      ),
                    ),
                  );
                } else if (state is InsightError) {
                  if (state.statusCode == 402 || state.message.toLowerCase().contains('paid plan')) {
                    return Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => const UpgradeToPaidScreen(),
                            ),
                          );
                        },
                        child: const Text('Upgrade to Paid'),
                      ),
                    );
                  }
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.w),
                      child: Text(
                        state.message,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                } else if (state is InsightLoaded) {
                  final _insightModel = state.insightData;

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: const Color(0xFFEAE6DF)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.lightbulb_rounded,
                                color: const Color(0xFFA88143),
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                widget.topicTitle,
                                style: TextStyle(
                                  fontFamily: 'Georgia',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          Container(
                            width: 48.w,
                            height: 1.h,
                            color: const Color(0xFFEAE6DF),
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            _insightModel.content,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13.sp,
                              color: const Color(0xFF475569),
                              height: 1.6,
                            ),
                          ),
                          SizedBox(height: 32.h),
                          Divider(color: const Color(0xFFEAE6DF), height: 1),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.verified,
                                    color: const Color(0xFFA88143),
                                    size: 12.sp,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    'Calculated with Precision\nAlgorithm v4.2',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 10.sp,
                                      color: const Color(0xFF94A3B8),
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: _regenerateInsight,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.refresh_rounded,
                                          size: 16.sp,
                                          color: const Color(0xFFA88143),
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          'Regenerate',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFFA88143),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 16.w),
                                  GestureDetector(
                                    onTap:
                                        () {}, // Add share functionality later
                                    child: Row(
                                      children: [
                                        Text(
                                          'Share',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF0F172A),
                                          ),
                                        ),
                                        SizedBox(width: 4.w),
                                        Icon(
                                          Icons.share,
                                          size: 16.sp,
                                          color: const Color(0xFF0F172A),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTopTab(String text, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? const Color(0xFF0F172A) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14.sp,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryPill(String text, bool isActive) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF0A0A0C) : Colors.white,
        border: Border.all(
          color: isActive ? Colors.transparent : const Color(0xFFEAE6DF),
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: isActive ? Colors.white : const Color(0xFF0F172A),
        ),
      ),
    );
  }

  Widget _buildToggle(String text, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(4.r),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ]
              : [],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: isActive ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
          ),
        ),
      ),
    );
  }

  Widget _buildSubSection(String title, String description) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF9F5),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: const Color(0xFFA88143),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            description,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.sp,
              color: const Color(0xFF0F172A),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniCard(IconData icon, String title, String description) {
}
