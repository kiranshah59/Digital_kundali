import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/kundali_bloc.dart';
import '../bloc/kundali_state.dart';
import '../bloc/kundali_event.dart';
import '../../profile/bloc/profile_bloc.dart';
import '../../profile/bloc/profile_state.dart';
import '../../../widgets/paid_plan_widget.dart';
import '../models/chart_model.dart';
import '../models/nepali_kundali_model.dart';
import '../../../widgets/kundali_painter.dart';
import 'rashi_screen.dart';

class ChartsTabScreen extends StatefulWidget {
  const ChartsTabScreen({super.key});

  @override
  State<ChartsTabScreen> createState() => _ChartsTabScreenState();
}

class _ChartsTabScreenState extends State<ChartsTabScreen> {
  bool _showEnglish = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        if (profileState is ProfileLoading || profileState is ProfileInitial) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFA88143)),
            ),
          );
        }

        String fullName = 'Unknown User';
        dynamic currentProfile;
        if (profileState is ProfileLoaded && profileState.profiles.isNotEmpty) {
          currentProfile = profileState.profiles.first;
          fullName = currentProfile['full_name'] ?? 'Unknown User';
        }

        return BlocBuilder<KundaliBloc, KundaliState>(
          builder: (context, state) {
            if (state is KundaliLoading || state is KundaliInitial) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFA88143)),
                ),
              );
            }

            if (state is KundaliError) {
              if (state.message.toLowerCase().contains('paid plan')) {
                return const SafeArea(child: PaidPlanWidget(featureName: 'Charts'));
              }
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(color: Colors.red, fontSize: 14.sp),
                ),
              );
            }

            if (state is KundaliLoaded) {
              return _buildContent(context, fullName, state, currentProfile);
            }

            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context, 
    String fullName, 
    KundaliLoaded state,
    dynamic profileData,
  ) {
    final chartModel = state.chartData;
    final nepaliModel = state.nepaliData;
    final nepaliStatusCode = state.nepaliStatusCode;
    final nepaliErrorMessage = state.nepaliErrorMessage;

    Widget nepaliViewContent;
    if (nepaliModel != null) {
      nepaliViewContent = CustomPaint(
        painter: KundaliPainter(
          chartModel: chartModel,
          nepaliModel: nepaliModel,
          showEnglish: _showEnglish,
        ),
      );
    } else if (nepaliStatusCode == 402) {
      nepaliViewContent = const PaidPlanWidget(featureName: 'Nepali Kundali View');
    } else if (nepaliStatusCode == 403) {
      nepaliViewContent = const Center(
        child: Text('You do not have permission to view this chart.', textAlign: TextAlign.center),
      );
    } else {
      nepaliViewContent = Center(
        child: Text(nepaliErrorMessage ?? 'Failed to load Nepali Kundali', textAlign: TextAlign.center),
      );
    }

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fullName,
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 24.sp,
                color: const Color(0xFF11141A),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Lagna Chart (D1)',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 32.sp,
                color: const Color(0xFF11141A),
              ),
            ),
            SizedBox(height: 16.h),
            
            // Toggle
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFAF9F5),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: const Color(0xFFEAE6DF)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildToggle(
                      'Standard View',
                      _showEnglish,
                      () => setState(() => _showEnglish = true),
                    ),
                  ),
                  Expanded(
                    child: _buildToggle(
                      'Nepali Kundali View',
                      !_showEnglish,
                      () => setState(() => _showEnglish = false),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Visual Chart
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFEAE6DF)),
              ),
              child: Center(
                child: SizedBox(
                  width: 250.w,
                  height: 250.w,
                  child: _showEnglish
                    ? CustomPaint(
                        painter: KundaliPainter(
                          chartModel: chartModel,
                          nepaliModel: nepaliModel,
                          showEnglish: _showEnglish,
                        ),
                      )
                    : nepaliViewContent,
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // Ascendant Insight Card
            _buildAscendantCard(chartModel),
            SizedBox(height: 24.h),

            // Planetary Positions Card
            _buildPlanetaryCard(chartModel),
            SizedBox(height: 32.h),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RashiScreen(profileData: profileData),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      side: const BorderSide(color: Color(0xFFEAE6DF)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'VIEW RASHI',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF11141A),
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {}, // Empty for now, but matches screenshot
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      side: const BorderSide(color: Color(0xFFEAE6DF)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'FULL PROFILE',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF11141A),
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            
            // Regenerate Chart Button
            Center(
              child: TextButton(
                onPressed: () {
                   context.read<KundaliBloc>().add(LoadKundaliData(profileData: profileData, forceRefresh: true));
                },
                child: Text(
                  'REGENERATE CHART',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFA88143),
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF6E7D2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? const Color(0xFFA88143) : const Color(0xFF11141A),
          ),
        ),
      ),
    );
  }

  Widget _buildAscendantCard(ChartModel chartModel) {
    final asc = chartModel.chartData.ascendant;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF9F5),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFEAE6DF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ascendant Insight',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 20.sp,
              color: const Color(0xFF11141A),
            ),
          ),
          SizedBox(height: 24.h),
          _buildRow('SIGN', asc.sign),
          SizedBox(height: 16.h),
          _buildRow('NAKSHATRA', '${asc.nakshatra} \u00B7 Pada ${asc.pada}'),
        ],
      ),
    );
  }

  Widget _buildPlanetaryCard(ChartModel chartModel) {
    final planetsMap = chartModel.chartData.planets;
    final Map<String, String> displayNames = {
      'sun': 'SUN',
      'moon': 'MOON',
      'mercury': 'MERCURY',
      'venus': 'VENUS',
      'mars': 'MARS',
      'jupiter': 'JUPITER',
      'saturn': 'SATURN',
      'rahu': 'RAHU',
      'ketu': 'KETU',
    };

    final planets = displayNames.entries
        .map((e) => MapEntry(e.value, planetsMap[e.key]))
        .where((e) => e.value != null)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Planetary Alignment',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 20.sp,
            color: const Color(0xFF11141A),
          ),
        ),
        SizedBox(height: 16.h),
        Container(
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
                    Expanded(
                      flex: 2,
                      child: Text('HOUSE', style: _tableHeaderStyle(), textAlign: TextAlign.right),
                    ),
                  ],
                ),
              ),
              for (int i = 0; i < planets.length; i++)
                _buildTableRow(
                  planets[i].key,
                  planets[i].value!.sign,
                  '${planets[i].value!.degree}\u00B0${planets[i].value!.retrograde ? ' (R)' : ''}',
                  'House ${planets[i].value!.house}',
                  isEven: i % 2 != 0,
                  isLast: i == planets.length - 1,
                ),
            ],
          ),
        ),
      ],
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
    String degree,
    String house, {
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
                fontWeight: FontWeight.w700,
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
          Expanded(
            flex: 2,
            child: Text(
              house,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.sp,
                color: const Color(0xFF8A8A8A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
            color: const Color(0xFF8A8A8A),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14.sp,
            color: const Color(0xFF11141A),
          ),
        ),
      ],
    );
  }
}
