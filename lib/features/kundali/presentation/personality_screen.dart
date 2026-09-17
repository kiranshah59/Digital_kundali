import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/astrology_cubit.dart';
import '../bloc/astrology_state.dart';
import '../../../widgets/upgrade_to_paid_banner.dart';

class PersonalityScreen extends StatefulWidget {
  final dynamic profileData;

  const PersonalityScreen({
    super.key,
    required this.profileData,
  });

  @override
  State<PersonalityScreen> createState() => _PersonalityScreenState();
}

class _PersonalityScreenState extends State<PersonalityScreen> {
  @override
  void initState() {
    super.initState();
    final profileId = widget.profileData?['id'];
    if (profileId != null) {
      context.read<AstrologyCubit>().loadPersonality(profileId);
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
          '$fullName\'s Personality',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF11141A),
          ),
        ),
      ),
      body: BlocBuilder<AstrologyCubit, AstrologyState>(
        builder: (context, state) {
          return _buildPersonalityTab(state);
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
        return const Center(child: UpgradeToPaidBanner());
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
