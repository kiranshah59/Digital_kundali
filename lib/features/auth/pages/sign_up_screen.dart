import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../dashboard/pages/main_layout_screen.dart';
import 'login_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F5),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                    child: Column(
                      children: [

                        // Real Logo inside a square box
                        Container(
                          width: 160.w,
                          height: 160.h,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/splash.svg',
                                width: 50.w,
                                height: 50.h,
                              ),
                              SizedBox(height: 12.h),
                              Text.rich(
                                const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'DIGITAL ',
                                      style: TextStyle(color: Color(0xFF0A1B28)),
                                    ),
                                    TextSpan(
                                      text: 'KUNDALI',
                                      style: TextStyle(color: Color(0xFFA88143)),
                                    ),
                                  ],
                                ),
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 3.0,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(width: 30.w, height: 0.5.h, color: const Color(0xFFEAE6DF)),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                                    child: Icon(Icons.star, size: 6.sp, color: const Color(0xFFA88143)),
                                  ),
                                  Container(width: 30.w, height: 0.5.h, color: const Color(0xFFEAE6DF)),
                                ],
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                'YOUR BIRTH CHART, READ WITH CLARITY',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 5.sp,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.0,
                                  color: const Color(0xFF4A4A4A),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),
                        // Headings
                        Text(
                          'Create your celestial profile',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0A1B28), // Dark Navy
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'Begin your journey into astronomical\nprecision and spiritual insight.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.sp,
                            color: const Color(0xFF6B6B6B),
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 32.h),
                        // Form Card
                        Container(
                          padding: EdgeInsets.all(24.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAF9F5),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(color: const Color(0xFFEAE6DF)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 20.r,
                                offset: Offset(0, 10.h),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInputField('Full Name', 'Aries Native'),
                              SizedBox(height: 20.h),
                              _buildInputField('Email', 'native@cosmos.com'),
                              SizedBox(height: 20.h),
                              _buildInputField('Password', '••••••••', obscureText: true),
                              SizedBox(height: 20.h),
                              _buildInputField('Confirm Password', '••••••••', obscureText: true),
                              SizedBox(height: 24.h),
                              // Checkbox row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 20.w,
                                    height: 20.w,
                                    child: Checkbox(
                                      value: false,
                                      onChanged: (val) {},
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4.r),
                                      ),
                                      side: const BorderSide(color: Color(0xFFEAE6DF)),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Text.rich(
                                      TextSpan(
                                        text: 'I agree to the ',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 11.sp,
                                          color: const Color(0xFF8A8A8A),
                                          height: 1.5,
                                        ),
                                        children: const [
                                          TextSpan(
                                            text: 'Terms of Service',
                                            style: TextStyle(
                                              color: Color(0xFFA88143),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          TextSpan(text: ' and '),
                                          TextSpan(
                                            text: 'Privacy Policy',
                                            style: TextStyle(
                                              color: Color(0xFFA88143),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 32.h),
                              // Create Account Button
                              SizedBox(
                                width: double.infinity,
                                height: 52.h,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => const MainLayoutScreen(),
                                      ),
                                      (route) => false,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0A0A0C),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Create Account',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Icon(Icons.arrow_forward, size: 16.sp),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 32.h),
                              // OR JOIN WITH
                              Row(
                                children: [
                                  const Expanded(child: Divider(color: Color(0xFFEAE6DF))),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                                    child: Text(
                                      'OR JOIN WITH',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.5,
                                        color: const Color(0xFFB0B0B0),
                                      ),
                                    ),
                                  ),
                                  const Expanded(child: Divider(color: Color(0xFFEAE6DF))),
                                ],
                              ),
                              SizedBox(height: 24.h),
                              // Google Button
                              SizedBox(
                                width: double.infinity,
                                height: 52.h,
                                child: OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFAF9F5),
                                    side: const BorderSide(color: Color(0xFFEAE6DF)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/google.svg',
                                        width: 22.w,
                                        height: 22.h,
                                      ),
                                      SizedBox(width: 12.w),
                                      Text(
                                        'Google',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF202124),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        SizedBox(height: 32.h),
                        // Log In text
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: Text.rich(
                            TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13.sp,
                                color: const Color(0xFF6B6B6B),
                              ),
                              children: const [
                                TextSpan(
                                  text: 'Log In',
                                  style: TextStyle(
                                    color: Color(0xFF11141A),
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hint, {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF4A4A4A),
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          obscureText: obscureText,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.sp,
            color: const Color(0xFF11141A),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.sp,
              color: const Color(0xFFB0B0B0),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 12.h),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFEAE6DF)),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFA88143)),
            ),
            isDense: true,
          ),
        ),
      ],
    );
  }
}
