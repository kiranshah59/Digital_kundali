import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'lagna_chart_screen.dart';
import 'rashi_screen.dart';

class InsightsScreen extends StatefulWidget {
  final dynamic profileData;

  const InsightsScreen({super.key, this.profileData});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  bool _isDetailed = false;
  bool _showEnglish = true;

  @override
  Widget build(BuildContext context) {
    final String fullName = widget.profileData?['full_name'] ?? 'Unknown User';
    
    // Get initials
    final List<String> nameParts = fullName.split(' ').where((p) => p.isNotEmpty).toList();
    String initials = 'U';
    if (nameParts.isNotEmpty) {
      if (nameParts.length >= 2) {
        initials = '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
      } else {
        initials = nameParts[0].length >= 2 ? nameParts[0].substring(0, 2).toUpperCase() : nameParts[0].toUpperCase();
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF9F5),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: const Color(0xFF11141A), size: 24.sp),
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
                    child: Text(initials, style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(width: 4.w),
                  Icon(Icons.keyboard_arrow_down, size: 16.sp, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    Navigator.pop(context);
                  }),
                  SizedBox(width: 24.w),
                  _buildTopTab('Insights', true, () {}),
                  SizedBox(width: 24.w),
                  _buildTopTab('Rashi', false, () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => RashiScreen(profileData: widget.profileData)),
                    );
                  }),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            
            // Category Pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildCategoryPill('Health', true),
                  SizedBox(width: 12.w),
                  _buildCategoryPill('Education', false),
                  SizedBox(width: 12.w),
                  _buildCategoryPill('Marriage', false),
                ],
              ),
            ),
            SizedBox(height: 24.h),

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
                        _buildToggle('Simple', !_isDetailed, () => setState(() => _isDetailed = false)),
                        _buildToggle('Detailed', _isDetailed, () => setState(() => _isDetailed = true)),
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
                        _buildToggle('EN', _showEnglish, () => setState(() => _showEnglish = true)),
                        _buildToggle('NE', !_showEnglish, () => setState(() => _showEnglish = false)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Main Health Card
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
                      children: [
                        Icon(Icons.medical_services_rounded, color: const Color(0xFFA88143), size: 20.sp),
                        SizedBox(width: 8.w),
                        Text(
                          'Health & Vitality',
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
                    Text(
                      '"A robust alignment of the Lagna Lord suggests a natural resilience and strong constitution."',
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 22.sp,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0F172A),
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Container(width: 48.w, height: 1.h, color: const Color(0xFFEAE6DF)),
                    SizedBox(height: 24.h),
                    Text(
                      'Your astrological chart indicates a high degree of general vitality. The placement of the First House Lord in a Kendra house provides you with the physical stamina necessary to manage high-stress environments.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.sp,
                        color: const Color(0xFF475569),
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    _buildSubSection(
                      'PLANETARY STRENGTH',
                      'The Sun\'s position in Aries provides excellent recovery capabilities. You possess a natural drive to maintain physical wellness through active movement.',
                    ),
                    SizedBox(height: 16.h),
                    _buildSubSection(
                      'WELLNESS SUGGESTIONS',
                      'Prioritize hydration and consistent sleep cycles. Moderate fire-based activities (Agni Yoga) can help balance your internal metabolic furnace.',
                    ),
                    SizedBox(height: 32.h),
                    Divider(color: const Color(0xFFEAE6DF), height: 1),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.verified, color: const Color(0xFFA88143), size: 12.sp),
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
                            Text(
                              'Share\nReport',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Icon(Icons.share, size: 16.sp, color: const Color(0xFF0F172A)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Mini Cards List
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: _buildMiniCard(Icons.star_border, 'Daily Dasha', 'Jupiter Mahadasha continues to favor mental clarity and internal growth.'),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: _buildMiniCard(Icons.cloud_outlined, 'Transit Impact', 'Saturn\'s transit suggests a need for structural changes in your work-life balance.'),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: _buildMiniCard(Icons.shield_outlined, 'Moons Influence', 'Waning crescent phase indicates a good time for introspection and detoxification.'),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: 2, // Insights
          onTap: (index) {
            if (index == 0) {
              // Go back to dashboard
              Navigator.popUntil(context, (route) => route.isFirst);
            } else if (index == 1) {
              Navigator.pop(context); // Usually goes back to Charts
            }
          },
          backgroundColor: const Color(0xFFFAF9F5),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFFA88143),
          unselectedItemColor: const Color(0xFF8A8A8A),
          elevation: 0,
          selectedLabelStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_graph_rounded),
              label: 'Charts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb), // Filled icon for selected
              label: 'Insights',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school_outlined),
              label: 'Guru',
            ),
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
        border: Border.all(color: isActive ? Colors.transparent : const Color(0xFFEAE6DF)),
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
          boxShadow: isActive ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 2, offset: const Offset(0, 1))] : [],
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
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFEAE6DF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20.sp, color: const Color(0xFF0F172A)),
          SizedBox(height: 16.h),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F172A),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            description,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.sp,
              color: const Color(0xFF64748B),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
