import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AIGuruChatView extends StatefulWidget {
  final VoidCallback onBack;

  const AIGuruChatView({super.key, required this.onBack});

  @override
  State<AIGuruChatView> createState() => _AIGuruChatViewState();
}

class _AIGuruChatViewState extends State<AIGuruChatView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAppBar(),
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            children: [
              // Timestamp
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '10:25 AM',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.sp,
                    color: const Color(0xFF6B6B6B),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              // Chat bubble
              _buildAIBubble(),
              SizedBox(height: 16.h),
              // Timestamp
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '10:26 AM',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.sp,
                    color: const Color(0xFF6B6B6B),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
        _buildSuggestions(),
        _buildInputArea(),
      ],
    );
  }

  Widget _buildAppBar() {
    return Container(
      color: const Color(0xFFFAF9F5),
      padding: EdgeInsets.fromLTRB(8.w, 16.h, 16.w, 16.h),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: widget.onBack,
          ),
          // Icon Stack
          SizedBox(
            width: 40.w,
            height: 40.w,
            child: Stack(
              children: [
                  Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFF191B21), // Dark color
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(Icons.auto_awesome, color: const Color(0xFFF6D69F), size: 20.sp),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFAF9F5),
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: const BoxDecoration(
                          color: Color(0xFFC78B2E),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.star, color: Colors.white, size: 8.sp),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Guru',
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF11141A),
                  ),
                ),
                Text(
                  'Vedic Astro Intelligence',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11.sp,
                    color: const Color(0xFF6B6B6B),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.settings_outlined, color: const Color(0xFF11141A), size: 24.sp),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAIBubble() {
    return Container(
      margin: EdgeInsets.only(right: 48.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F6F0), // Very light beige, slightly darker than background
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
          bottomRight: Radius.circular(16.r),
          bottomLeft: Radius.circular(4.r), // Chat tail effect
        ),
        border: Border.all(color: const Color(0xFFEAE6DF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "For career, we must look at the 10th house. Saturn's current position suggests a period of consolidation. You might feel increased responsibility. Here is your current transit alignment:",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14.sp,
              color: const Color(0xFF11141A),
              height: 1.5,
            ),
          ),
          SizedBox(height: 16.h),
          // Chart Placeholder
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFEAE6DF)),
            ),
            child: AspectRatio(
              aspectRatio: 1,
              child: CustomPaint(
                painter: KundaliChartPainter(),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 16.h),
                        child: Text(
                          'Jup',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFC78B2E), // Gold text
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.architecture, color: const Color(0xFFD6D6D6), size: 48.sp),
                          Text(
                            'TRANSIT',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF11141A),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: Text(
                          'Sat',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.sp,
                            color: const Color(0xFF8A8A8A), // Grey text
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    return Container(
      height: 36.h,
      margin: EdgeInsets.only(bottom: 16.h),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        children: [
          _buildSuggestionChip(Icons.access_time, 'When is my Shubh Muhurat?'),
          SizedBox(width: 8.w),
          _buildSuggestionChip(Icons.work_outline, 'Analyze my career...'),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFEAE6DF)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: const Color(0xFF11141A)),
          SizedBox(width: 6.w),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.sp,
              color: const Color(0xFF11141A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
      decoration: const BoxDecoration(
        color: Color(0xFFFAF9F5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF9F6F0),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: const Color(0xFFEAE6DF)),
              ),
              child: Row(
                children: [
                  SizedBox(width: 16.w),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Ask Guru about your stars...',
                        hintStyle: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.sp,
                          color: const Color(0xFF8A8A8A),
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.sp,
                        color: const Color(0xFF11141A),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.mic_none, color: const Color(0xFF8A8A8A), size: 20.sp),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: const Color(0xFF12141D),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: IconButton(
              icon: Icon(Icons.send_rounded, color: Colors.white, size: 20.sp),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class KundaliChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFEAE6DF)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw outer border just in case
    // canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Draw an X and a diamond
    canvas.drawLine(const Offset(0, 0), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);
    
    // Draw the inner diamond
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(0, size.height / 2)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
