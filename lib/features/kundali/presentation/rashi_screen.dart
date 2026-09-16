import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'insights_main_screen.dart';
import '../data/chart_service.dart';
import 'package:intl/intl.dart';

class RashiScreen extends StatefulWidget {
  final dynamic profileData;

  const RashiScreen({super.key, this.profileData});

  @override
  State<RashiScreen> createState() => _RashiScreenState();
}

class _RashiScreenState extends State<RashiScreen> {
  bool _isDetailed = false;
  bool _showEnglish = true;
  String _selectedTime = 'Today';

  Map<String, dynamic>? _dashaData;
  bool _isLoadingDasha = false;
  String? _dashaError;

  @override
  void initState() {
    super.initState();
    _fetchDashaData();
  }

  Future<void> _fetchDashaData() async {
    final profileId = widget.profileData?['id'];
    if (profileId == null) return;

    setState(() {
      _isLoadingDasha = true;
      _dashaError = null;
    });

    final lang = _showEnglish ? 'en' : 'ne';
    final style = _isDetailed ? 'technical' : 'simple';

    final res = await ChartService.getDasha(
      profileId,
      language: lang,
      style: style,
    );

    if (mounted) {
      setState(() {
        _isLoadingDasha = false;
        if (res['success']) {
          _dashaData = res['data'];
        } else {
          _dashaError = res['message'];
        }
      });
    }
  }

  void _onToggleLanguage(bool isEnglish) {
    if (_showEnglish != isEnglish) {
      setState(() {
        _showEnglish = isEnglish;
      });
      _fetchDashaData();
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
          fullName,
          style: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF11141A),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFFEAE6DF)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12.r,
                    backgroundColor: const Color(0xFF11141A),
                    child: Text(
                      initials,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 16.sp,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top Tab Bar
            Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFEAE6DF))),
              ),
              child: Row(
                children: [
                  SizedBox(width: 24.w),
                  _buildTopTab('Charts', false, () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }),
                  SizedBox(width: 24.w),
                  _buildTopTab('Insights', false, () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InsightsMainScreen(),
                      ),
                    );
                  }),
                  SizedBox(width: 24.w),
                  _buildTopTab('Rashi', true, () {}),
                ],
              ),
            ),
            SizedBox(height: 32.h),

            // Icon
            Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFFEAE6DF)),
              ),
              child: Center(
                child: Icon(
                  Icons.card_giftcard,
                  color: const Color(0xFFA88143),
                  size: 36.sp,
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Title
            Text(
              'Simha (Leo)',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0F172A),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'THE CELESTIAL MONARCH',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: const Color(0xFFA88143),
              ),
            ),
            SizedBox(height: 32.h),

            // Time Toggles
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F5F2),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Row(
                  children: [
                    _buildTimeToggle('Today'),
                    _buildTimeToggle('Week'),
                    _buildTimeToggle('Month'),
                    _buildTimeToggle('Year'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Settings Toggles
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
                        _buildToggle(
                          'Simple',
                          !_isDetailed,
                          () => setState(() => _isDetailed = false),
                        ),
                        _buildToggle(
                          'Detailed',
                          _isDetailed,
                          () => setState(() => _isDetailed = true),
                        ),
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
                        _buildToggle(
                          'EN',
                          _showEnglish,
                          () => setState(() => _showEnglish = true),
                        ),
                        _buildToggle(
                          'NE',
                          !_showEnglish,
                          () => setState(() => _showEnglish = false),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),

            // About Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'About Simha (Leo)',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAE6DF),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        _buildMiniToggle('EN', true),
                        _buildMiniToggle('NE', false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
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
                    Text(
                      'As a Simha (Leo) native, you are ruled by the Sun, the source of life and vitality. You possess a natural charisma and a commanding presence that often places you in leadership positions. Your personality is characterized by a noble heart, immense creative energy, and a steadfast sense of loyalty. In this period, your solar influence is heightened, encouraging you to step into the spotlight with confidence.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.sp,
                        color: const Color(0xFF475569),
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCF4E6),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            'FIRE SIGN',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFA88143),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E2433),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            'FIXED MODALITY',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32.h),

            // Current Dasha Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Current Dasha',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAE6DF),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        _buildMiniToggle(
                          'EN',
                          _showEnglish,
                          onTap: () => _onToggleLanguage(true),
                        ),
                        _buildMiniToggle(
                          'NE',
                          !_showEnglish,
                          onTap: () => _onToggleLanguage(false),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            if (_isLoadingDasha)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 40.h),
                child: Center(
                  child: CircularProgressIndicator(
                    color: const Color(0xFFA88143),
                  ),
                ),
              )
            else if (_dashaError != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: Colors.red.withAlpha(25),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.red.withAlpha(75)),
                  ),
                  child: Text(
                    _dashaError!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              )
            else if (_dashaData != null)
              Padding(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'MAHADASHA',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF94A3B8),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                '${_dashaData?['current_mahadasha']?['lord'] ?? 'Unknown'}',
                                style: TextStyle(
                                  fontFamily: 'Georgia',
                                  fontSize: 18.sp,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.stars,
                            color: const Color(0xFFA88143),
                            size: 24.sp,
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      Stack(
                        children: [
                          Container(
                            height: 4.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAE6DF),
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                          Container(
                            height: 4.h,
                            width: 200.w, // Progress indicator
                            decoration: BoxDecoration(
                              color: const Color(0xFFA88143),
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ANTARDASHA',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF94A3B8),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                '${_dashaData?['current_antardasha']?['lord'] ?? 'Unknown'}',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Ends on',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10.sp,
                                  color: const Color(0xFF94A3B8),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                _formatDate(
                                  _dashaData?['current_antardasha']?['end_date'] ??
                                      '',
                                ),
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (_dashaData?['explanation']?['content'] != null) ...[
                        SizedBox(height: 24.h),
                        Divider(color: const Color(0xFFEAE6DF)),
                        SizedBox(height: 16.h),
                        Text(
                          _dashaData!['explanation']['content'],
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.sp,
                            color: const Color(0xFF475569),
                            height: 1.6,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            SizedBox(height: 32.h),

            // Dosha Check Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  Text(
                    'Dosha Check',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: _buildDoshaCard(
                'Mangal Dosha',
                'Moderate Influence',
                true,
                true,
              ),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: _buildDoshaCard(
                'Shani (Sade Sati)',
                'Not Active',
                false,
                false,
              ),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: _buildDoshaCard(
                'Kaal Sarp Dosha',
                'No Dosha Found',
                false,
                false,
              ),
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

  Widget _buildTimeToggle(String text) {
    bool isActive = text == _selectedTime;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTime = text),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF0A0A0C) : Colors.transparent,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : const Color(0xFF64748B),
              ),
            ),
          ),
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

  Widget _buildMiniToggle(String text, bool isActive, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
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
            fontSize: 8.sp,
            fontWeight: FontWeight.w600,
            color: isActive ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
          ),
        ),
      ),
    );
  }

  Widget _buildDoshaCard(
    String title,
    String subtitle,
    bool hasDosha,
    bool showRemedies,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFEAE6DF)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: hasDosha
                      ? const Color(0xFFFFF5F5)
                      : const Color(0xFFF8F9FA),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    hasDosha ? Icons.emergency : Icons.check_circle_outline,
                    color: hasDosha
                        ? const Color(0xFFD35555)
                        : const Color(0xFFD4AF37),
                    size: 16.sp,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10.sp,
                      color: hasDosha
                          ? const Color(0xFFD35555)
                          : const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (showRemedies)
            Text(
              'Remedies',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFA88143),
              ),
            ),
        ],
      ),
    );
  }
}
