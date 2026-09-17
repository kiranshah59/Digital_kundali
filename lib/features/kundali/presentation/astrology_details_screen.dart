import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/astrology_cubit.dart';
import '../bloc/astrology_state.dart';
import '../../../widgets/upgrade_to_paid_banner.dart';

class AstrologyDetailsScreen extends StatefulWidget {
  final dynamic profileData;
  final int initialTabIndex;

  const AstrologyDetailsScreen({
    super.key,
    required this.profileData,
    this.initialTabIndex = 0,
  });

  @override
  State<AstrologyDetailsScreen> createState() => _AstrologyDetailsScreenState();
}

class _AstrologyDetailsScreenState extends State<AstrologyDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Personality', 'Dasha', 'Dosha', 'Rashi'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _tabController.addListener(_handleTabSelection);

    // Initial load
    _loadDataForTab(widget.initialTabIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) return;
    _loadDataForTab(_tabController.index);
  }

  void _loadDataForTab(int index) {
    final profileId = widget.profileData?['id'];
    if (profileId == null) return;

    final cubit = context.read<AstrologyCubit>();
    switch (index) {
      case 0:
        cubit.loadPersonality(profileId);
        break;
      case 1:
        cubit.loadDasha(profileId);
        break;
      case 2:
        cubit.loadDoshaFlags(profileId);
        break;
      case 3:
        cubit.loadRashi(profileId);
        break;
    }
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fullName = widget.profileData?['full_name'] ?? 'Unknown User';

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
          fullName,
          style: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF11141A),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.h),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFEAE6DF),
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: const Color(0xFFA88143),
              unselectedLabelColor: const Color(0xFF5A5A5A),
              indicatorColor: const Color(0xFFA88143),
              indicatorWeight: 2,
              tabAlignment: TabAlignment.start,
              labelStyle: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
            ),
          ),
        ),
      ),
      body: BlocBuilder<AstrologyCubit, AstrologyState>(
        builder: (context, state) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildPersonalityTab(state),
              _buildDashaTab(state),
              _buildDoshaTab(state),
              _buildRashiTab(state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStateWrapper(AstrologyState state, Widget child, {Map<String, dynamic>? dataToWatch}) {
    if (state is AstrologyLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFA88143)),
        ),
      );
    } else if (state is AstrologyPolling) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFA88143)),
            ),
            SizedBox(height: 16.h),
            Text(
              state.message,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.sp,
                color: const Color(0xFF5A5A5A),
              ),
            ),
          ],
        ),
      );
    } else if (state is AstrologyError) {
      if (state.statusCode == 402) {
        return const UpgradeToPaidBanner(
          featureName: 'Premium Astrology Insights',
        );
      }
      return Center(
        child: Text(
          state.message,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14.sp,
            color: const Color(0xFFD35555),
          ),
          textAlign: TextAlign.center,
        ),
      );
    } else if (state is AstrologyLoaded) {
      if (dataToWatch == null) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFA88143)),
          ),
        );
      }
      return child;
    }
    return const SizedBox();
  }

  Widget _buildPersonalityTab(AstrologyState state) {
    Map<String, dynamic>? data;
    if (state is AstrologyLoaded) {
      data = state.personality;
    }

    return _buildStateWrapper(
      state,
      data != null
          ? ListView(
              padding: EdgeInsets.all(24.w),
              physics: const BouncingScrollPhysics(),
              children: [
                _buildCard(
                  title: 'Overview',
                  content: data['summary'] ?? 'No summary available.',
                  icon: Icons.person_outline,
                ),
                SizedBox(height: 16.h),
                _buildListCard(
                  title: 'Strengths',
                  items: List<String>.from(data['strengths'] ?? []),
                  icon: Icons.trending_up,
                  iconColor: const Color(0xFF2E7D32),
                ),
                SizedBox(height: 16.h),
                _buildListCard(
                  title: 'Weaknesses',
                  items: List<String>.from(data['weaknesses'] ?? []),
                  icon: Icons.trending_down,
                  iconColor: const Color(0xFFD35555),
                ),
              ],
            )
          : const SizedBox(),
      dataToWatch: data,
    );
  }

  Widget _buildDashaTab(AstrologyState state) {
    Map<String, dynamic>? data;
    if (state is AstrologyLoaded) {
      data = state.dasha;
    }

    return _buildStateWrapper(
      state,
      data != null
          ? ListView(
              padding: EdgeInsets.all(24.w),
              physics: const BouncingScrollPhysics(),
              children: [
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF11141A),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Phase',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                          color: const Color(0xFFA88143),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mahadasha',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12.sp,
                                    color: Colors.white70,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  data['current_mahadasha'] ?? 'N/A',
                                  style: TextStyle(
                                    fontFamily: 'Georgia',
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Antardasha',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12.sp,
                                    color: Colors.white70,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  data['current_antardasha'] ?? 'N/A',
                                  style: TextStyle(
                                    fontFamily: 'Georgia',
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (data['explanation'] != null &&
                    data['explanation']['status'] == 'completed') ...[
                  SizedBox(height: 24.h),
                  _buildCard(
                    title: 'Analysis',
                    content: data['explanation']['content'] ?? '',
                    icon: Icons.analytics_outlined,
                  ),
                ],
                SizedBox(height: 24.h),
                Text(
                  'Dasha Sequence',
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF11141A),
                  ),
                ),
                SizedBox(height: 12.h),
                ...(data['sequence'] as List<dynamic>? ?? []).map((period) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xFFEAE6DF)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          period['lord'] ?? '',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF11141A),
                          ),
                        ),
                        Text(
                          '${_formatDate(period['start_date'] ?? '')} - ${_formatDate(period['end_date'] ?? '')}',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12.sp,
                            color: const Color(0xFF5A5A5A),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            )
          : const SizedBox(),
      dataToWatch: data,
    );
  }

  Widget _buildDoshaTab(AstrologyState state) {
    Map<String, dynamic>? data;
    if (state is AstrologyLoaded) {
      data = state.doshaFlags;
    }

    return _buildStateWrapper(
      state,
      data != null
          ? ListView(
              padding: EdgeInsets.all(24.w),
              physics: const BouncingScrollPhysics(),
              children: [
                _buildDoshaFlag(
                  'Mangal Dosha',
                  data['mangal_dosha'],
                ),
                SizedBox(height: 16.h),
                _buildDoshaFlag(
                  'Kaal Sarp Dosha',
                  data['kaal_sarp_dosha'],
                ),
              ],
            )
          : const SizedBox(),
      dataToWatch: data,
    );
  }

  Widget _buildDoshaFlag(String title, Map<String, dynamic>? dosha) {
    if (dosha == null) return const SizedBox();

    final isPresent = dosha['present'] == true;
    final severity = dosha['severity']; // "strong"|"moderate"|null
    final details = dosha['details'];
    final explanation = dosha['explanation'];

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isPresent ? const Color(0xFFFEF2F2) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isPresent ? const Color(0xFFFECACA) : const Color(0xFFEAE6DF),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF11141A),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isPresent ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  isPresent ? 'DETECTED' : 'NOT DETECTED',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          if (isPresent) ...[
            if (severity != null) ...[
              SizedBox(height: 12.h),
              Text(
                'Severity: ${severity.toString().toUpperCase()}',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF991B1B),
                ),
              ),
            ],
            if (details != null) ...[
              SizedBox(height: 8.h),
              Text(
                details,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.sp,
                  color: const Color(0xFF11141A),
                  height: 1.5,
                ),
              ),
            ],
            if (explanation != null && explanation['status'] == 'completed') ...[
              SizedBox(height: 16.h),
              const Divider(color: Color(0xFFFECACA)),
              SizedBox(height: 12.h),
              Text(
                'Analysis',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF11141A),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                explanation['content'] ?? '',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.sp,
                  color: const Color(0xFF5A5A5A),
                  height: 1.6,
                ),
              ),
            ] else if (explanation != null && explanation['status'] == 'processing') ...[
              SizedBox(height: 16.h),
              Row(
                children: [
                  SizedBox(
                    width: 16.w,
                    height: 16.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDC2626)),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Generating detailed analysis...',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.sp,
                      color: const Color(0xFFDC2626),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ]
          ] else ...[
            SizedBox(height: 12.h),
            Text(
              'No indications of $title found in this birth chart.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.sp,
                color: const Color(0xFF5A5A5A),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRashiTab(AstrologyState state) {
    Map<String, dynamic>? data;
    if (state is AstrologyLoaded) {
      data = state.rashi;
    }

    return _buildStateWrapper(
      state,
      data != null
          ? ListView(
              padding: EdgeInsets.all(24.w),
              physics: const BouncingScrollPhysics(),
              children: [
                Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: const Color(0xFFEAE6DF)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 72.w,
                        height: 72.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAF9F5),
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFEAE6DF)),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.nights_stay_outlined,
                            color: const Color(0xFFA88143),
                            size: 32.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Moon Sign (Rashi)',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                          color: const Color(0xFF5A5A5A),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        data['name'] ?? 'Unknown Rashi',
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF11141A),
                        ),
                      ),
                      if (data['description'] != null) ...[
                        SizedBox(height: 16.h),
                        Text(
                          data['description'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.sp,
                            color: const Color(0xFF5A5A5A),
                            height: 1.5,
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ],
            )
          : const SizedBox(),
      dataToWatch: data,
    );
  }

  Widget _buildCard({required String title, required String content, required IconData icon}) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFEAE6DF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20.sp, color: const Color(0xFFA88143)),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF11141A),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            content,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14.sp,
              color: const Color(0xFF5A5A5A),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListCard({
    required String title,
    required List<String> items,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFEAE6DF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20.sp, color: iconColor),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF11141A),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          if (items.isEmpty)
            Text(
              'No items to display.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.sp,
                color: const Color(0xFF5A5A5A),
              ),
            )
          else
            ...items.map((item) => Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 6.h, right: 8.w),
                        child: CircleAvatar(
                          radius: 3.r,
                          backgroundColor: iconColor.withOpacity(0.5),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.sp,
                            color: const Color(0xFF11141A),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
        ],
      ),
    );
  }
}
