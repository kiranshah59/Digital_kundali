import 'package:digital_kundali_app/screens/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onNext;

  const SplashScreen({super.key, required this.onNext});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      if (!mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OnboardingScreen(onNext: () {}),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F5),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const Spacer(flex: 3),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Container(
                          width: 290.w,
                          height: 280.h,
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/splash.svg',
                                width: 100.w,
                                height: 100.h,
                              ),
                              SizedBox(height: 8.h),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.normal,
                                      letterSpacing: 6.5,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'DIGITAL ',
                                        style: TextStyle(
                                          color: Color(0xFF11141A),
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'KUNDALI',
                                        style: TextStyle(
                                          color: Color(0xFFA88143),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 12.h),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 120.w,
                                      height: 1,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            const Color(
                                              0xFFA88143,
                                            ).withValues(alpha: 0.0),
                                            const Color(
                                              0xFFA88143,
                                            ).withValues(alpha: 0.5),
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: SizedBox(
                                        width: 10.w,
                                        height: 10.h,
                                        child: CustomPaint(
                                          painter: _SparklePainter(),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 120.w,
                                      height: 1,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            const Color(
                                              0xFFA88143,
                                            ).withValues(alpha: 0.5),
                                            const Color(
                                              0xFFA88143,
                                            ).withValues(alpha: 0.0),
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                'YOUR BIRTH CHART, READ WITH CLARITY',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 6.sp,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.5,
                                  color: Color(0xFF11141A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 34.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Container(
                          width: 280.w,
                          height: 1,
                          color: const Color(0xFFEAE6DF),
                        ),
                      ),
                      SizedBox(height: 25.h),
                      Text(
                        'Your birth chart, read with clarity.',
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontStyle: FontStyle.italic,
                          fontSize: 20.sp,
                          color: Color(0xFF4A4A4A),
                        ),
                      ),
                      const Spacer(flex: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 40.w,
                              height: 1,
                              color: const Color(0xFFDFD8CB),
                            ),
                            SizedBox(width: 14.w),
                            Text(
                              'CALCULATED WITH PRECISION',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                                color: Color(0xFFC2A878),
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Container(
                              width: 40.w,
                              height: 1,
                              color: const Color(0xFFDFD8CB),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          4,
                          (index) => Container(
                            margin: EdgeInsets.symmetric(horizontal: 3.w),
                            width: 4.w,
                            height: 4.h,
                            decoration: const BoxDecoration(
                              color: Color(0xFFD1D1D1),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 60.h),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SparklePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFA88143)
      ..style = PaintingStyle.fill;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final path = Path()
      ..moveTo(cx, 0)
      ..quadraticBezierTo(cx, cy, size.width, cy)
      ..quadraticBezierTo(cx, cy, cx, size.height)
      ..quadraticBezierTo(cx, cy, 0, cy)
      ..quadraticBezierTo(cx, cy, cx, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
