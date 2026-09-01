import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

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
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 24.h,
                    ),
                    child: Column(
                      children: [
                        // Top bar: Back and Logo
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.arrow_back,
                                    size: 18.sp,
                                    color: Color(0xFF4A4A4A),
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'BACK',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.0,
                                      color: Color(0xFF4A4A4A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Top right box removed
                          ],
                        ),
                        SizedBox(height: 32),

                        // Logo Box
                        Container(
                          width: 140.w,
                          height: 140,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/splash.svg',
                                width: 44.w,
                                height: 44,
                              ),
                              SizedBox(height: 10),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'DIGITAL ',
                                      style: TextStyle(
                                        color: Color(0xFF0A1B28),
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
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 2.5,
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 24.w,
                                    height: 0.5,
                                    color: const Color(0xFFEAE6DF),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4.w,
                                    ),
                                    child: Icon(
                                      Icons.star,
                                      size: 5.sp,
                                      color: Color(0xFFA88143),
                                    ),
                                  ),
                                  Container(
                                    width: 24.w,
                                    height: 0.5,
                                    color: const Color(0xFFEAE6DF),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text(
                                'YOUR BIRTH CHART, READ WITH CLARITY',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 5.sp,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.0,
                                  color: Color(0xFF4A4A4A),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 32),

                        // Headings
                        Text(
                          'Reset Password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0A1B28), // Dark Navy
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Enter the email address associated with your\naccount and we\'ll send you a link to reset\nyour password.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.sp,
                            color: Color(0xFF6B6B6B),
                            height: 1.5,
                          ),
                        ),

                        SizedBox(height: 40),

                        // Email Field
                        _buildLabel('EMAIL ADDRESS'),
                        SizedBox(height: 4),
                        _buildTextField('name@example.com'),

                        SizedBox(height: 32),

                        // Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF050B14),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'SEND RESET LINK',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Icon(Icons.arrow_forward, size: 16),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 32),

                        // Back to Login
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.login,
                                size: 16.sp,
                                color: Color(0xFF6B6B6B),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Back to Login',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF6B6B6B),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),
                        SizedBox(height: 32),

                        // Footer
                        SizedBox(height: 24),
                        Text(
                          '© 2024 Digital Kundali. All celestial movements calculated\nprecisely.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10.sp,
                            color: Color(0xFF9FA5AE),
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 8),
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

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
          color: Color(0xFF6B6B6B),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint) {
    return TextField(
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 15.sp,
        color: Color(0xFF11141A),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 15.sp,
          color: Color(0xFFB0B0B0),
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
    );
  }
}
