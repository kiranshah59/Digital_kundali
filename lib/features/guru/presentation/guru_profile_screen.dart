import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GuruProfileScreen extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double rating;
  final String sessions;

  const GuruProfileScreen({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.sessions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF9F5),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: const Color(0xFF11141A), size: 24.sp),
          onPressed: () {
            Navigator.pop(context); // Fallback to back action
          },
        ),
        title: Text(
          'Digital Kundali',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF11141A),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings_outlined, color: const Color(0xFF11141A), size: 24.sp),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: CircleAvatar(
              radius: 14.r,
              backgroundColor: const Color(0xFFEAE6DF),
              backgroundImage: const NetworkImage('https://randomuser.me/api/portraits/men/32.jpg'), // Using a placeholder
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Divider under app bar
            Divider(height: 1, thickness: 1, color: const Color(0xFFEAE6DF)),
            
            // Image Section
            Padding(
              padding: EdgeInsets.all(16.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 350.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: double.infinity,
                    height: 350.h,
                    color: Colors.grey[300],
                    child: const Icon(Icons.person, size: 80, color: Colors.white),
                  ),
                ),
              ),
            ),
            
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Certification Badge
                  Row(
                    children: [
                      Icon(Icons.verified, color: const Color(0xFFB5852A), size: 16.sp),
                      SizedBox(width: 6.w),
                      Text(
                        'MAHARISHI CERTIFIED',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFB5852A),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  
                  // Name
                  Text(
                    name,
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xFF11141A),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  
                  // Bio
                  Text(
                    'Descendant of the Kashi Vidvat Parishad\nlineage, specializing in Parashara and\nJaimini systems. A trusted guide for\nglobal leaders seeking mathematical\nprecision in spiritual alignment.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.sp,
                      height: 1.5,
                      color: const Color(0xFF4A4A4A), // slightly lighter than black
                    ),
                  ),
                  SizedBox(height: 24.h),
                  
                  // Stats (Rating and Next Availability)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F1EC),
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(color: const Color(0xFFEAE6DF)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star_border, color: const Color(0xFFB5852A), size: 16.sp),
                        SizedBox(width: 8.w),
                        Text(
                          '${rating.toStringAsFixed(1)} ($sessions)',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF11141A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F1EC),
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(color: const Color(0xFFEAE6DF)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.access_time, color: const Color(0xFFB5852A), size: 16.sp),
                        SizedBox(width: 8.w),
                        Text(
                          'Next: Today, 4:00 PM',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF11141A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  
                  // Action Buttons
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D0F17),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 16.sp, color: Colors.white),
                          SizedBox(width: 8.w),
                          Text(
                            'Chat Now',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF11141A)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phone_outlined, size: 16.sp, color: const Color(0xFF11141A)),
                          SizedBox(width: 8.w),
                          Text(
                            'Voice Call',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF11141A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF11141A)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.auto_awesome, size: 16.sp, color: const Color(0xFFB5852A)),
                          SizedBox(width: 8.w),
                          Text(
                            'VVIP Report',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFB5852A), // The text is also brownish/gold in the image
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 48.h),
                ],
              ),
            ),
            
            // Details Section (Lineage, Mastery, Consultation)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: const Color(0xFFEAE6DF)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Lineage & Philosophy
                  Text(
                    'Lineage & Philosophy',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF11141A),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Born into a family of royal astrologers\nin Varanasi, Pandit Somnath has spent\nfour decades decoding the celestial\nmathematics of the Vedas. His\napproach bridges the gap between\nancient Sanskrit scriptures and the\ncomplexities of modern existential\nchallenges.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.sp,
                      height: 1.6,
                      color: const Color(0xFF4A4A4A),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'He believes that the Kundali is not a\nfixed destiny but a celestial roadmap\n—a series of probabilities that can be\nnavigated with the right awareness\nand remedial measures (Upayas).',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.sp,
                      height: 1.6,
                      color: const Color(0xFF4A4A4A),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  
                  // Areas of Mastery
                  Text(
                    'AREAS OF MASTERY',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: const Color(0xFF11141A),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  _buildMasteryItem(
                    icon: Icons.favorite_border,
                    title: 'Marriage & Relationships',
                    subtitle: 'Matching, Mangal Dosha, and timing for unions.',
                  ),
                  SizedBox(height: 24.h),
                  _buildMasteryItem(
                    icon: Icons.work_outline,
                    title: 'Career & Growth',
                    subtitle: 'Professional pivot points and business success.',
                  ),
                  SizedBox(height: 24.h),
                  _buildMasteryItem(
                    icon: Icons.account_balance_outlined,
                    title: 'Wealth & Prosperity',
                    subtitle: 'Laxmi Yoga analysis and wealth preservation.',
                  ),
                  SizedBox(height: 40.h),
                  
                  // Consultation
                  Text(
                    'Consultation',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF11141A),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  _buildPricingItem('Quick Chat', '15 Minutes', '₹499'),
                  Divider(height: 32.h, color: const Color(0xFFEAE6DF)),
                  _buildPricingItem('Deep Dive Call', '30 Minutes', '₹1,299'),
                  Divider(height: 32.h, color: const Color(0xFFEAE6DF)),
                  _buildPricingItem('Annual Report', 'Digital PDF', '₹2,999'),
                  SizedBox(height: 24.h),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8A5A19), // Brown color
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'BOOK APPOINTMENT',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            
            // Trust Guarantee
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F1EC), // light cream
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(color: const Color(0xFFEAE6DF)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.shield_outlined, color: const Color(0xFFB5852A), size: 18.sp),
                        SizedBox(width: 8.w),
                        Text(
                          'Trust Guarantee',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF11141A),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Privacy is paramount. All consultations are\nencrypted and strictly confidential.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.sp,
                        height: 1.5,
                        color: const Color(0xFF4A4A4A),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40.h),
            
            // Seeker Experiences
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Seeker Experiences',
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF11141A),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Verified feedback from our community',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.sp,
                          color: const Color(0xFF4A4A4A),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'View All',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF11141A),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            
            // Reviews
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  _buildReviewCard(
                    quote: '"Pandit ji\'s insight into my career\ntransition was eerily accurate. His\nsuggested remedies were simple but\nhave made a profound impact."',
                    initials: 'AK',
                    name: 'Aditi Kapoor',
                    location: 'Mumbai, India',
                  ),
                  SizedBox(height: 16.h),
                  _buildReviewCard(
                    quote: '"Mathematical precision is what I look\nfor. Pandit Somnath explained the\nplanetary transits like an astronomer.\nExceptional depth."',
                    initials: 'DS',
                    name: 'David S.',
                    location: 'London, UK',
                  ),
                  SizedBox(height: 16.h),
                  _buildReviewCard(
                    quote: '"Truly authoritative. He doesn\'t\nsugarcoat; he provides the truth with\ncompassionate guidance. Highly\nrecommended."',
                    initials: 'RV',
                    name: 'Rajesh Varma',
                    location: 'Delhi, India',
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 100.h), // padding for bottom nav
          ],
        ),
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFAF9F5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(Icons.dashboard_outlined, 'Dashboard', false),
                _buildNavItem(Icons.show_chart, 'Charts', false),
                _buildNavItem(Icons.lightbulb_outline, 'Insights', false),
                _buildNavItem(Icons.people_outline, 'Profiles', false),
                _buildNavItem(Icons.school, 'Guru', true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMasteryItem({required IconData icon, required String title, required String subtitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFFB5852A), size: 24.sp),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF11141A),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.sp,
                  height: 1.5,
                  color: const Color(0xFF4A4A4A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPricingItem(String title, String subtitle, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF11141A),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.sp,
                color: const Color(0xFF4A4A4A),
              ),
            ),
          ],
        ),
        Text(
          price,
          style: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF11141A),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCard({
    required String quote,
    required String initials,
    required String name,
    required String location,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F1EC),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFEAE6DF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
              5,
              (index) => Padding(
                padding: EdgeInsets.only(right: 4.w),
                child: Icon(Icons.star, color: const Color(0xFFC78B2E), size: 14.sp),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            quote,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.sp,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
              height: 1.6,
              color: const Color(0xFF11141A),
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0DBD2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF11141A),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF11141A),
                    ),
                  ),
                  Text(
                    location,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11.sp,
                      color: const Color(0xFF6B6B6B),
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

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: isSelected
          ? BoxDecoration(
              color: const Color(0xFFF6D69F).withOpacity(0.3),
              borderRadius: BorderRadius.circular(20.r),
            )
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF8A5A19) : const Color(0xFF6B6B6B),
            size: 24.sp,
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? const Color(0xFF8A5A19) : const Color(0xFF6B6B6B),
            ),
          ),
        ],
      ),
    );
  }
}
