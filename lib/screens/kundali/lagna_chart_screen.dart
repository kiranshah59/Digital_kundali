import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/kundali_painter.dart';
import '../../core/services/chart_service.dart';
import '../../models/chart_model.dart';
import '../../models/nepali_kundali_model.dart';
import 'insights_screen.dart';
import 'rashi_screen.dart';

class LagnaChartScreen extends StatefulWidget {
  final dynamic profileData;

  const LagnaChartScreen({super.key, this.profileData});

  @override
  State<LagnaChartScreen> createState() => _LagnaChartScreenState();
}

class _LagnaChartScreenState extends State<LagnaChartScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  ChartModel? _chartModel;
  NepaliKundaliModel? _nepaliKundaliModel;
  bool _showEnglish = true;

  @override
  void initState() {
    super.initState();
    _fetchChartData();
  }

  Future<void> _fetchChartData() async {
    final String fullName = widget.profileData?['full_name'] ?? 'Unknown';
    final profileId = widget.profileData?['id'] ?? fullName.hashCode.abs();
    
    if (profileId == null) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Invalid profile data (Missing ID)';
        });
      }
      return;
    }

    // 1. Try to get existing chart
    var chartRes = await ChartService.getChart(profileId);
    
    // 2. If 404, generate chart
    if (!chartRes['success'] && chartRes['statusCode'] == 404) {
      chartRes = await ChartService.generateChart(profileId);
    }

    if (!chartRes['success']) {
      if (mounted) {
        setState(() {
          _errorMessage = chartRes['message'];
          _isLoading = false;
        });
      }
      return;
    }

    final ChartModel chartModel = chartRes['data'];
    _chartModel = chartModel;

    // 3. Get Nepali Kundali Layout
    final nepaliRes = await ChartService.getNepaliKundali(chartModel.id);
    
    if (mounted) {
      setState(() {
        if (nepaliRes['success']) {
          _nepaliKundaliModel = nepaliRes['data'];
        } else {
          _errorMessage = nepaliRes['message'];
        }
        _isLoading = false;
      });
    }
  }

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

    final risingSign = _chartModel?.chartData.ascendant.sign ?? 'Leo';
    final moonSign = _chartModel?.chartData.planets['moon']?.sign ?? 'Scorpio';
    
    String risingCap = risingSign.isNotEmpty ? risingSign.substring(0, 1).toUpperCase() + risingSign.substring(1) : '';

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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFFA88143)),
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, color: const Color(0xFFD35555), size: 48.sp),
                        SizedBox(height: 16.h),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'Inter', fontSize: 14.sp, color: const Color(0xFF11141A)),
                        ),
                        SizedBox(height: 24.h),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isLoading = true;
                              _errorMessage = null;
                            });
                            _fetchChartData();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFA88143),
                          ),
                          child: const Text('Retry'),
                        )
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tabs
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InsightsScreen(profileData: widget.profileData),
                                    ),
                                  );
                                },
                                child: _buildPillTab('Insights', Icons.lightbulb_outline, false),
                              ),
                              SizedBox(width: 8.w),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RashiScreen(profileData: widget.profileData),
                                    ),
                                  );
                                },
                                child: _buildPillTab('Rashi', Icons.adjust, false),
                              ),
                              SizedBox(width: 8.w),
                              _buildPillTab('Dashas', Icons.menu_book, false),
                            ],
                          ),
                        ),
                        SizedBox(height: 32.h),
                        
                        Text(
                          'PRIMARY READING',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            color: const Color(0xFF8A8A8A),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Lagna Chart (D1)',
                              style: TextStyle(
                                fontFamily: 'Georgia',
                                fontSize: 24.sp,
                                color: const Color(0xFF11141A),
                              ),
                            ),
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
                        SizedBox(height: 16.h),
                        
                        // Chart Box
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(24.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: const Color(0xFFEAE6DF)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'LAT: 28.6139° N\nLON: 77.2090° E',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 8.sp,
                                  color: const Color(0xFF8A8A8A),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Center(
                                child: SizedBox(
                                  width: 250.w,
                                  height: 250.w,
                                  child: CustomPaint(
                                    painter: KundaliPainter(
                                      kundaliData: _nepaliKundaliModel,
                                      showEnglish: _showEnglish,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Planetary Status Section
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(24.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F5F2), // Beige background
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Planetary Status',
                                    style: TextStyle(
                                      fontFamily: 'Georgia',
                                      fontSize: 18.sp,
                                      color: const Color(0xFF11141A),
                                    ),
                                  ),
                                  Icon(Icons.bar_chart, color: const Color(0xFFA88143), size: 20.sp),
                                ],
                              ),
                              SizedBox(height: 24.h),
                              
                              if (_chartModel != null)
                                ..._chartModel!.chartData.planets.entries.map((e) => _buildPlanetaryStatusRow(e.key, e.value)),

                              SizedBox(height: 24.h),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0A0A0C),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Generate Full Planetary Report',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Icon(Icons.auto_awesome, color: Colors.white, size: 16.sp),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),
                        
                        // Interpretation
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(24.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(color: const Color(0xFFEAE6DF)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'INTERPRETATION',
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
                                'Ascendant Insight',
                                style: TextStyle(
                                  fontFamily: 'Georgia',
                                  fontSize: 18.sp,
                                  color: const Color(0xFF11141A),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'With $risingCap rising at ${_chartModel?.chartData.ascendant.degree.toStringAsFixed(0) ?? 5} degrees, your personality is marked by a solar radiance. The Sun as your Lagna Lord is strongly placed, indicating a natural leadership ability and a robust physical constitution.',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12.sp,
                                  color: const Color(0xFF5A6273),
                                  height: 1.6,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Row(
                                children: [
                                  Text(
                                    'Read full analysis',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF11141A),
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Icon(Icons.arrow_forward, size: 16.sp, color: const Color(0xFF11141A)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Remedial Suggestion
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(24.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF070B19), // Very dark navy
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Remedial Suggestion',
                                style: TextStyle(
                                  fontFamily: 'Georgia',
                                  fontSize: 18.sp,
                                  color: const Color(0xFFFDE0AD), // Light gold
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'Your Moon in $moonSign suggests intense emotional depths. To balance this, consider wearing a natural pearl (Moti) set in silver on a Monday morning.',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12.sp,
                                  color: const Color(0xFF8A92A6),
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
          currentIndex: 1, // Charts
          onTap: (index) {
            if (index == 0) {
              Navigator.pop(context); // Go back to dashboard
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
              icon: Icon(Icons.lightbulb_outline_rounded),
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

  Widget _buildPillTab(String text, IconData icon, bool isActive) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.transparent,
        border: Border.all(color: const Color(0xFFEAE6DF)),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14.sp, color: isActive ? const Color(0xFFA88143) : const Color(0xFF8A8A8A)),
          SizedBox(width: 6.w),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.sp,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isActive ? const Color(0xFF11141A) : const Color(0xFF8A8A8A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle(String text, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
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
            color: isActive ? const Color(0xFF11141A) : const Color(0xFF8A8A8A),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanetaryStatusRow(String key, PlanetData data) {
    String abbr = key.substring(0, 1).toUpperCase() + (key.length > 1 ? key.substring(1, 2) : '');
    String name = key.substring(0, 1).toUpperCase() + key.substring(1);
    
    // Pick a random tag for visual purposes
    String tag = 'NEUTRAL';
    Color tagColor = const Color(0xFF8A8A8A);
    Color tagBgColor = const Color(0xFFEAE6DF);
    if (key == 'sun') { tag = 'PURVA PHALGUNI'; }
    if (key == 'moon') { tag = 'DEBILITATED'; tagColor = const Color(0xFFD35555); tagBgColor = const Color(0xFFFADCDC); }
    if (key == 'mars') { tag = 'MOOLATRIKONA'; }
    if (key == 'mercury') { tag = 'EXALTED'; }
    if (key == 'jupiter') { tag = 'SWAKSHETRA'; }

    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xFFEAE6DF)),
            ),
            child: Center(
              child: Text(
                abbr,
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 16.sp,
                  color: const Color(0xFF11141A),
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF11141A),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '${data.sign} (${data.sign.substring(0, 3)})',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10.sp,
                    color: const Color(0xFF8A8A8A),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${data.degree.toStringAsFixed(2)}°',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFA88143),
                ),
              ),
              SizedBox(height: 4.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: tagBgColor,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w700,
                    color: tagColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
