import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../profile/bloc/profile_bloc.dart';
import '../../profile/bloc/profile_state.dart';
import 'lagna_chart_screen.dart';
import 'insights_main_screen.dart';
import 'rashi_screen.dart';
import '../../profile/presentation/edit_profile_screen.dart';
import '../../profile/data/profile_service.dart';
import '../../auth/data/auth_service.dart';
import '../../auth/presentation/login_screen.dart';
import '../models/chart_model.dart';
import '../models/nepali_kundali_model.dart';
import '../data/chart_service.dart';
import '../../../widgets/kundali_painter.dart';
import '../../../widgets/paid_plan_widget.dart';
import '../utils/kundali_pdf_helper.dart';

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
  late dynamic _currentProfileData;

  @override
  void initState() {
    super.initState();
    _currentProfileData = widget.profileData;
    if (_currentProfileData == null) {
      final profileState = context.read<ProfileBloc>().state;
      if (profileState is ProfileLoaded && profileState.profiles.isNotEmpty) {
        _currentProfileData = profileState.profiles.first;
      }
    }
    _fetchChartData();
  }

  Future<void> _fetchChartData() async {
    if (_currentProfileData == null) return;
    
    final String fullName = _currentProfileData!['full_name'] ?? 'Unknown User';
    final profileId = _currentProfileData!['id'] ?? fullName.hashCode.abs();

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
        if (chartRes['statusCode'] == 401) {
          await ProfileService.clearProfiles();
          await AuthService.logout();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(chartRes['message'] ?? 'Session expired')),
          );
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
          return;
        }

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
    if (_currentProfileData == null) {
      final profileState = context.watch<ProfileBloc>().state;
      if (profileState is ProfileLoaded && profileState.profiles.isNotEmpty) {
        _currentProfileData = profileState.profiles.first;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _fetchChartData();
        });
      } else {
        return const Scaffold(
          backgroundColor: Color(0xFFFAF9F5),
          body: Center(child: CircularProgressIndicator(color: Color(0xFFA88143))),
        );
      }
    }

    final String fullName = _currentProfileData?['full_name'] ?? 'Unknown User';
    final String firstName = fullName.split(' ').first;

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

    final String initialLetter = fullName.isNotEmpty
        ? fullName[0].toUpperCase()
        : 'U';

    final risingSign = _chartModel?.chartData.ascendant.sign ?? 'N/A';
    final sunSign = _chartModel?.chartData.planets['sun']?.sign ?? 'N/A';
    final moonSign = _chartModel?.chartData.planets['moon']?.sign ?? 'N/A';

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF9F5),
        elevation: 0,
        automaticallyImplyLeading: false, // Prevent default back button
        titleSpacing: widget.profileData != null ? NavigationToolbar.kMiddleSpacing : 24.w,
        leading: widget.profileData != null ? IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: const Color(0xFF11141A),
            size: 24.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ) : null,
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
                  if (widget.profileData != null) ...[
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 16.sp,
                      color: Colors.grey,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  const Color(0xFFA88143),
                ),
              ),
            )
          : _errorMessage != null
          ? _errorMessage!.toLowerCase().contains('paid plan')
                ? const PaidPlanWidget(featureName: 'Birth Chart')
                : Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
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
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14.sp,
                              color: const Color(0xFF11141A),
                            ),
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
                          ),
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
                            child: Icon(
                              Icons.star,
                              size: 10.sp,
                              color: const Color(0xFF11141A),
                            ),
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
                                builder: (context) => LagnaChartScreen(
                                  profileData: _currentProfileData,
                                ),
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
                                builder: (context) => const InsightsMainScreen(),
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
                                builder: (context) => RashiScreen(
                                  profileData: _currentProfileData,
                                ),
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
                        Container(
                          width: 1,
                          height: 24.h,
                          color: const Color(0xFFEAE6DF),
                          margin: EdgeInsets.symmetric(horizontal: 16.w),
                        ),
                        _buildPlacement('SUN', sunSign),
                        Container(
                          width: 1,
                          height: 24.h,
                          color: const Color(0xFFEAE6DF),
                          margin: EdgeInsets.symmetric(horizontal: 16.w),
                        ),
                        _buildPlacement('MOON', moonSign),
                      ],
                    ),
                    SizedBox(height: 32.h),

                    // Natal Parameters Card
                    _buildNatalParametersCard(_currentProfileData),
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
                      ],
                    ),
                    SizedBox(height: 16.h),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LagnaChartScreen(
                              profileData: _currentProfileData,
                            ),
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
                ), // Column
              ), // Padding
            ), // SingleChildScrollView
    ); // Scaffold
  }

  Widget _buildTab(String text, bool isActive) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.transparent,
        border: Border.all(
          color: isActive ? const Color(0xFFEAE6DF) : Colors.transparent,
        ),
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
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 16.sp,
                      color: const Color(0xFFA88143),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    onPressed: () async {
                      final updatedData = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditProfileScreen(profileData: profileData),
                        ),
                      );
                      if (updatedData != null) {
                        setState(() {
                          _currentProfileData = {
                            ...Map<String, dynamic>.from(
                              _currentProfileData ?? {},
                            ),
                            ...Map<String, dynamic>.from(updatedData),
                          };
                        });
                        _fetchChartData();
                      }
                    },
                  ),
                  SizedBox(width: 8.w),
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      size: 16.sp,
                      color: Colors.red,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () async {
                      final bool? confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Profile'),
                          content: const Text(
                            'Are you sure you want to delete this birth profile?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true && mounted) {
                        final id = _currentProfileData?['id'];
                        if (id != null) {
                          final response = await ProfileService.deleteProfile(
                            id,
                          );
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  response['message'] ??
                                      'Profile deleted successfully',
                                ),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        }
                      }
                    },
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.auto_awesome,
                    size: 16.sp,
                    color: const Color(0xFFA88143),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 24.h),

          _buildParamRow(
            'DATE OF BIRTH',
            profileData?['date_of_birth'] ?? 'August 31, 1990',
          ),
          SizedBox(height: 16.h),
          _buildParamRow(
            'TIME OF BIRTH',
            profileData?['time_of_birth'] ?? '08:45 AM',
          ),
          SizedBox(height: 16.h),
          _buildParamRow(
            'PLACE OF BIRTH',
            profileData?['place_of_birth'] ??
                profileData?['birth_place_name'] ??
                'New Delhi, India',
          ),

          SizedBox(height: 24.h),
          Divider(color: const Color(0xFFEAE6DF), height: 1),
          SizedBox(height: 16.h),

          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 12.sp,
                color: const Color(0xFF8A8A8A),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Coordinates: ${profileData?['latitude'] ?? '28.6139'}° N, ${profileData?['longitude'] ?? '77.2090'}° E',
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
          border: Border.all(
            color: isActive ? Colors.transparent : const Color(0xFFEAE6DF),
          ),
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
                chartModel: _chartModel,
                nepaliModel: _nepaliKundaliModel,
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
                  Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF7C353),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Benefic\nInfluence',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10.sp,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xFF8A8A8A),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF09595),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Malefic\nAspect',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10.sp,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xFF8A8A8A),
                    ),
                  ),
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
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.r),
                topRight: Radius.circular(8.r),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text('PLANET', style: _tableHeaderStyle()),
                ),
                Expanded(
                  flex: 2,
                  child: Text('SIGN', style: _tableHeaderStyle()),
                ),
                Expanded(
                  flex: 2,
                  child: Text('DEGREE', style: _tableHeaderStyle()),
                ),
              ],
            ),
          ),
          for (int i = 0; i < planets.length; i++)
            _buildTableRow(
              planets[i].key.toUpperCase(),
              planets[i].value.sign,
              '${planets[i].value.degree}°',
              isEven: i % 2 != 0,
              isLast: i == planets.length - 1,
            ),
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

  Widget _buildTableRow(
    String planet,
    String sign,
    String degree, {
    required bool isEven,
    bool isLast = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: isEven ? const Color(0xFFFCFAF8) : Colors.white,
        borderRadius: isLast
            ? BorderRadius.only(
                bottomLeft: Radius.circular(8.r),
                bottomRight: Radius.circular(8.r),
              )
            : BorderRadius.zero,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              planet,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF11141A),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              sign,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.sp,
                color: const Color(0xFF4A4A4A),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              degree,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFA88143),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonaCard(
    String firstName,
    String risingSign,
    String sunSign,
    String moonSign,
  ) {
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
              Icon(
                Icons.face_retouching_natural,
                color: const Color(0xFFA88143),
                size: 24.sp,
              ),
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
              GestureDetector(
                onTap: () {
                  if (_currentProfileData != null && _currentProfileData['id'] != null) {
                    KundaliPdfHelper.generateAndDownloadPdf(context, _currentProfileData['id']);
                  }
                },
                child: Container(
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
