import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'ai_guru_chat_view.dart';
import 'guru_profile_screen.dart';


class GuruScreen extends StatefulWidget {
  final String? userName;
  const GuruScreen({super.key, this.userName});

  @override
  State<GuruScreen> createState() => _GuruScreenState();
}

class _GuruScreenState extends State<GuruScreen> {
  bool _showChat = false;

  @override
  Widget build(BuildContext context) {
    if (_showChat) {
      return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) return;
          setState(() {
            _showChat = false;
          });
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFFAF9F5),
          body: SafeArea(
            child: AIGuruChatView(
              onBack: () {
                setState(() {
                  _showChat = false;
                });
              },
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F5),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildAIGuruBanner(),
                  SizedBox(height: 32.h),
                  _buildVerifiedExpertsHeader(),
                  SizedBox(height: 24.h),
                  _buildExpertCard(
                    name: 'Acharya Vashistha',
                    subtitle: 'VEDIC ASTROLOGY, VASTU',
                    rating: 4.9,
                    sessions: '2,400+ Sessions',
                    experience: '22 Years Experience',
                    languages: 'Sanskrit, Hindi, English',
                    imageUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
                  ),
                  SizedBox(height: 16.h),
                  _buildExpertCard(
                    name: 'Dr. Meera Iyer',
                    subtitle: 'PALMISTRY, GEMOLOGY',
                    rating: 4.8,
                    sessions: '1,850+ Sessions',
                    experience: '15 Years Experience',
                    languages: 'Tamil, English, Hindi',
                    imageUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
                  ),
                  SizedBox(height: 16.h),
                  _buildExpertCard(
                    name: 'Pandit K. Sharma',
                    subtitle: 'NADI ASTROLOGY, KP SYSTEM',
                    rating: 5.0,
                    sessions: '4,100+ Sessions',
                    experience: '35 Years Experience',
                    languages: 'Hindi, Gujarati, English',
                    imageUrl: 'https://randomuser.me/api/portraits/men/85.jpg',
                  ),
                  SizedBox(height: 32.h),
                  _buildTrustedBySeekers(),
                  SizedBox(height: 48.h),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      backgroundColor: const Color(0xFFFAF9F5),
      elevation: 0,
      pinned: true,
      titleSpacing: 24.w,
      title: Row(
        children: [
          CircleAvatar(
            radius: 16.r,
            backgroundColor: const Color(0xFFEAE6DF),
            child: Icon(Icons.person, size: 20.sp, color: Colors.grey),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'Digital Kundali',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF11141A),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.settings_outlined,
            color: const Color(0xFF11141A),
            size: 24.sp,
          ),
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  Widget _buildAIGuruBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: const Color(0xFF12141D),
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2419),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Text(
              'INSTANT INTELLIGENCE',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFE2A662),
                letterSpacing: 1.0,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Consult the AI Guru',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFFAF9F5),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Harness the power of neural-\nmapped Vedic logic. Get instant\nanswers to your life path,\nplanetary transits, and daily\nalignment.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14.sp,
              height: 1.5,
              color: const Color(0xFFB0B7C3),
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _showChat = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF6D69F),
              foregroundColor: const Color(0xFF11141A),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.r),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'START CONSULTATION',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(Icons.auto_awesome, size: 18.sp),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifiedExpertsHeader() {
    return Column(
      children: [
        Center(
          child: Text(
            'Verified Experts',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF11141A),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 44.h,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by name or expe',
                    hintStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.sp,
                      color: const Color(0xFF8A8A8A),
                    ),
                    prefixIcon: Icon(Icons.search, color: const Color(0xFF8A8A8A), size: 20.sp),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 40.w,
                      minHeight: 40.h,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF3EFE9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12.w),
                  ),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.sp,
                    color: const Color(0xFF11141A),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Container(
              height: 44.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFEAE6DF)),
                borderRadius: BorderRadius.circular(4.r),
                color: Colors.transparent,
              ),
              child: Row(
                children: [
                  Icon(Icons.filter_list, color: const Color(0xFF11141A), size: 18.sp),
                  SizedBox(width: 6.w),
                  Text(
                    'Filter',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF11141A),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExpertCard({
    required String name,
    required String subtitle,
    required double rating,
    required String sessions,
    required String experience,
    required String languages,
    required String imageUrl,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFEAE6DF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: SizedBox(
                  width: 64.w,
                  height: 64.w,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[400],
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(Icons.star, color: const Color(0xFFC78B2E), size: 14.sp),
                      SizedBox(width: 4.w),
                      Text(
                        rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFC78B2E),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    sessions,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11.sp,
                      color: const Color(0xFF11141A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            name,
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF11141A),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFC78B2E),
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Icon(Icons.menu_book_outlined, size: 14.sp, color: const Color(0xFF6B6B6B)),
              SizedBox(width: 8.w),
              Text(
                experience,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.sp,
                  color: const Color(0xFF6B6B6B),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(Icons.language_outlined, size: 14.sp, color: const Color(0xFF6B6B6B)),
              SizedBox(width: 8.w),
              Text(
                languages,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.sp,
                  color: const Color(0xFF6B6B6B),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            height: 44.h,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GuruProfileScreen(
                    name: name,
                    imageUrl: imageUrl,
                    rating: rating,
                    sessions: sessions,
                  )),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF11141A)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'CONSULT',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF11141A),
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(Icons.arrow_forward, color: const Color(0xFF11141A), size: 16.sp),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustedBySeekers() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: const Color(0xFF191B21),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trusted by Seekers\nWorldwide',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Every guru in our directory undergoes\na rigorous 5-step verification process\nfocusing on lineage, knowledge, and\nethical practice.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.sp,
              color: const Color(0xFFB0B7C3),
              height: 1.5,
            ),
          ),
          SizedBox(height: 24.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xFF22242B),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '"The insight provided by\nAcharya Vashistha regarding my\nSaturn transit was remarkably\naccurate and practical. The UI\nmakes it so easy to connect."',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.sp,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12.r,
                      backgroundColor: const Color(0xFFF6D69F),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Vikram R., Tech Lead',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
