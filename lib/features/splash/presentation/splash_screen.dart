import 'package:flutter/material.dart';
import 'package:digital_kundali_app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



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
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        widget.onNext();
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
                          child: Center(
                            child: Image.asset(
                              'assets/images/splash.png',
                              fit: BoxFit.contain,
                            ),
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
                          3,
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
