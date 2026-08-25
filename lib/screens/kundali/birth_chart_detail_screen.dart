import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/kundali_painter.dart';
import '../../core/services/chart_service.dart';
import '../../models/chart_model.dart';
import '../../models/nepali_kundali_model.dart';
import 'lagna_chart_screen.dart';
import 'insights_screen.dart';
import 'rashi_screen.dart';

class BirthChartDetailScreen extends StatefulWidget {
  final dynamic profileData;

  const BirthChartDetailScreen({super.key, this.profileData});

  @override
  State<BirthChartDetailScreen> createState() => _BirthChartDetailScreenState();
}

class _BirthChartDetailScreenState extends State<BirthChartDetailScreen> {
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

    var chartRes = await ChartService.getChart(profileId);
    
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
    final String firstName = fullName.split(' ').first;
    
    final List<String> nameParts = fullName.split(' ').where((p) => p.isNotEmpty).toList();
    String initials = 'U';
    if (nameParts.isNotEmpty) {
      if (nameParts.length >= 2) {
        initials = '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
      } else {
        initials = nameParts[0].length >= 2 ? nameParts[0].substring(0, 2).toUpperCase() : nameParts[0].toUpperCase();
      }
    }
    
    final String initialLetter = fullName.isNotEmpty ? fullName[0].toUpperCase() : 'U';

    final risingSign = _chartModel?.chartData.ascendant.sign ?? 'N/A';
    final sunSign = _chartModel?.chartData.planets['sun']?.sign ?? 'N/A';
    final moonSign = _chartModel?.chartData.planets['moon']?.sign ?? 'N/A';

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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Avatar box
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 80.w,
                              height: 80.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  initialLetter,
                                  style: TextStyle(
                                    fontFamily: 'Georgia',
                                    fontSize: 40.sp,
                                    color: const Color(0xFF11141A),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: -4,
                              bottom: -4,
                              child: Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7C353),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: Icon(Icons.star, size: 10.sp, color: const Color(0xFF11141A)),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          fullName,
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF11141A),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '${risingSign.toUpperCase()} DOMINANT',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            color: const Color(0xFFA88143),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        
                        // Tabs
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LagnaChartScreen(profileData: widget.profileData),
                                  ),
                                );
                              },
                              child: _buildTab('Charts', true),
                            ),
                            SizedBox(width: 8.w),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => InsightsScreen(profileData: widget.profileData),
                                  ),
                                );
                              },
                              child: _buildTab('Insights', false),
                            ),
                            SizedBox(width: 8.w),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RashiScreen(profileData: widget.profileData),
                                  ),
                                );
                              },
                              child: _buildTab('Rashi', false),
                            ),
                          ],
                        ),
                        SizedBox(height: 32.h),
                        
                        // Key Placements
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildPlacement('RISING', risingSign),
                            Container(width: 1, height: 24.h, color: const Color(0xFFEAE6DF), margin: EdgeInsets.symmetric(horizontal: 16.w)),
                            _buildPlacement('SUN', sunSign),
                            Container(width: 1, height: 24.h, color: const Color(0xFFEAE6DF), margin: EdgeInsets.symmetric(horizontal: 16.w)),
                            _buildPlacement('MOON', moonSign),
                          ],
                        ),
                        SizedBox(height: 32.h),
                        
                        // Natal Parameters Card
                        _buildNatalParametersCard(widget.profileData),
                        SizedBox(height: 32.h),
                        
                        // Lagna Chart (D1)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Lagna Chart (D1)',
                              style: TextStyle(
                                fontFamily: 'Georgia',
                                fontSize: 14.sp,
                                color: const Color(0xFF11141A),
                              ),
                            ),
                            Row(
                              children: [
                                _buildToggle('EN', _showEnglish, () => setState(() => _showEnglish = true)),
                                _buildToggle('NE', !_showEnglish, () => setState(() => _showEnglish = false)),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LagnaChartScreen(profileData: widget.profileData),
                              ),
                            );
                          },
                          child: _buildChartBox(),
                        ),
                        SizedBox(height: 32.h),
                        
                        // Planetary Alignment Table
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Planetary Alignment',
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 14.sp,
                              color: const Color(0xFF11141A),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        _buildPlanetaryTable(),
                        SizedBox(height: 32.h),
                        
                        // Celestial Persona Card
                        _buildPersonaCard(firstName, risingSign, sunSign, moonSign),
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

  Widget _buildTab(String text, bool isActive) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.transparent,
        border: Border.all(color: isActive ? const Color(0xFFEAE6DF) : Colors.transparent),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12.sp,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          color: const Color(0xFF11141A),
        ),
      ),
    );
  }

  Widget _buildPlacement(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF8A8A8A),
            letterSpacing: 1.0,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF11141A),
          ),
        ),
      ],
    );
  }

  Widget _buildNatalParametersCard(dynamic profileData) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFCF9), // Off-white to match design
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Natal Parameters',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 12.sp,
                  color: const Color(0xFF11141A),
                ),
              ),
              Icon(Icons.auto_awesome, size: 16.sp, color: const Color(0xFFA88143)),
            ],
          ),
          SizedBox(height: 24.h),
          
          _buildParamRow('DATE OF BIRTH', profileData?['date_of_birth'] ?? 'August 31, 1990'),
          SizedBox(height: 16.h),
          _buildParamRow('TIME OF BIRTH', profileData?['time_of_birth'] ?? '08:45 AM'),
          SizedBox(height: 16.h),
          _buildParamRow('PLACE OF BIRTH', profileData?['place_of_birth'] ?? 'New Delhi, India'),
          
          SizedBox(height: 24.h),
          Divider(color: const Color(0xFFEAE6DF), height: 1),
          SizedBox(height: 16.h),
          
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 12.sp, color: const Color(0xFF8A8A8A)),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Coordinates: 28.6139° N, 77.2090° E',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10.sp,
                    color: const Color(0xFF8A8A8A),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildParamRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF8A8A8A),
            letterSpacing: 1.0,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF11141A),
          ),
        ),
      ],
    );
  }

  Widget _buildToggle(String text, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF0A0A0C) : Colors.white,
          border: Border.all(color: isActive ? Colors.transparent : const Color(0xFFEAE6DF)),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : const Color(0xFF11141A),
          ),
        ),
      ),
    );
  }

  Widget _buildChartBox() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 250.w,
            height: 250.w,
            child: CustomPaint(
              painter: KundaliPainter(
                kundaliData: _nepaliKundaliModel,
                showEnglish: _showEnglish,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Container(width: 6.w, height: 6.w, decoration: const BoxDecoration(color: Color(0xFFF7C353), shape: BoxShape.circle)),
                  SizedBox(width: 8.w),
                  Text('Benefic\nInfluence', style: TextStyle(fontFamily: 'Inter', fontSize: 10.sp, fontStyle: FontStyle.italic, color: const Color(0xFF8A8A8A))),
                ],
              ),
              Row(
                children: [
                  Container(width: 6.w, height: 6.w, decoration: const BoxDecoration(color: Color(0xFFF09595), shape: BoxShape.circle)),
                  SizedBox(width: 8.w),
                  Text('Malefic\nAspect', style: TextStyle(fontFamily: 'Inter', fontSize: 10.sp, fontStyle: FontStyle.italic, color: const Color(0xFF8A8A8A))),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlanetaryTable() {
    if (_chartModel == null || _chartModel!.chartData.planets.isEmpty) {
      return Container();
    }
    
    final planets = _chartModel!.chartData.planets.entries.toList();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F3F0),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(8.r), topRight: Radius.circular(8.r)),
            ),
            child: Row(
              children: [
                Expanded(flex: 2, child: Text('PLANET', style: _tableHeaderStyle())),
                Expanded(flex: 2, child: Text('SIGN', style: _tableHeaderStyle())),
                Expanded(flex: 2, child: Text('DEGREE', style: _tableHeaderStyle())),
              ],
            ),
          ),
          // Rows
          for (int i = 0; i < planets.length; i++)
            _buildTableRow(
              planets[i].key.toUpperCase(),
              planets[i].value.sign,
              '${planets[i].value.degree.toStringAsFixed(2)}°',
              isEven: i % 2 != 0,
              isLast: i == planets.length - 1,
            )
        ],
      ),
    );
  }

  TextStyle _tableHeaderStyle() {
    return TextStyle(
      fontFamily: 'Inter',
      fontSize: 10.sp,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.0,
      color: const Color(0xFF11141A),
    );
  }

  Widget _buildTableRow(String planet, String sign, String degree, {required bool isEven, bool isLast = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: isEven ? const Color(0xFFFCFAF8) : Colors.white,
        borderRadius: isLast ? BorderRadius.only(bottomLeft: Radius.circular(8.r), bottomRight: Radius.circular(8.r)) : BorderRadius.zero,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2, 
            child: Text(
              planet, 
              style: TextStyle(fontFamily: 'Inter', fontSize: 12.sp, fontWeight: FontWeight.w600, color: const Color(0xFF11141A)),
            ),
          ),
          Expanded(
            flex: 2, 
            child: Text(
              sign, 
              style: TextStyle(fontFamily: 'Inter', fontSize: 12.sp, color: const Color(0xFF4A4A4A)),
            ),
          ),
          Expanded(
            flex: 2, 
            child: Text(
              degree, 
              style: TextStyle(fontFamily: 'Inter', fontSize: 12.sp, fontWeight: FontWeight.w500, color: const Color(0xFFA88143)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonaCard(String firstName, String risingSign, String sunSign, String moonSign) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: const Color(0xFF161A26), // Dark Navy
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.face_retouching_natural, color: const Color(0xFFA88143), size: 24.sp),
              SizedBox(width: 8.w),
              Text(
                'Celestial Persona',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFA88143),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            'With a dominant $risingSign placement in Rising and $sunSign Sun, $firstName possesses a magnetic, authoritative presence and a deep-seated need for creative self-expression. The moon in $moonSign acts as a vital anchor, grounding this fiery vitality with meticulous precision and an analytical emotional core. This rare combination suggests a path defined by leadership that is both visionary and pragmatically executed.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.sp,
              color: const Color(0xFFD4D6DB),
              height: 1.6,
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDE0AD), // Light gold
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'Generate\nFull Report',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF11141A),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  'AI ANALYSIS V2.4 •\nUPDATED TODAY',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                    color: const Color(0xFF5A6273),
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
