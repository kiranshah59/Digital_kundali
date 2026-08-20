import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'sign_up_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                        // White box for logo
                        Container(
                          width: 160.w,
                          height: 160,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/splash.svg',
                                width: 50.w,
                                height: 50,
                              ),
                              SizedBox(height: 12),
                              Text.rich(
                                TextSpan(
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
                              SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(width: 30.w, height: 0.5, color: const Color(0xFFEAE6DF)),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                                    child: Icon(Icons.star, size: 6.sp, color: Color(0xFFA88143)),
                                  ),
                                  Container(width: 30.w, height: 0.5, color: const Color(0xFFEAE6DF)),
                                ],
                              ),
                              SizedBox(height: 6),
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
                          'Welcome Back',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0A1B28), // Dark Navy
                          ),
                        ),
                        SizedBox(height: 12),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.w),
                          child: Text(
                            'Reconnect with your celestial path\nand cosmic insights.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14.sp,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFF6B6B6B),
                              height: 1.4,
                            ),
                          ),
                        ),
                        SizedBox(height: 32),
                        // Email Field
                        _buildLabel('EMAIL ADDRESS'),
                        SizedBox(height: 8),
                        _buildTextField('your@email.com'),
                        
                        SizedBox(height: 20),
                        
                        // Password Field
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildLabel('PASSWORD'),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Forgot password?',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFA88143),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        _buildTextField('••••••••', obscureText: true),
                        
                        SizedBox(height: 32),
                        
                        // Sign In Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF050B14), // Very dark navy/black
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'SIGN IN',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 32),
                        // OR CONTINUE WITH
                        Row(
                          children: [
                            Expanded(child: Divider(color: Color(0xFFEAE6DF))),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Text(
                                'OR CONTINUE WITH',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.0,
                                  color: Color(0xFF6B6B6B),
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: Color(0xFFEAE6DF))),
                          ],
                        ),
                        
                        SizedBox(height: 24),
                        // Google Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              backgroundColor: const Color(0xFFFAF9F5),
                              side: const BorderSide(color: Color(0xFFEAE6DF)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/google.svg',
                                  width: 20.w,
                                  height: 20,
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  'Google',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF202124),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const Spacer(),
                        SizedBox(height: 32),
                        // Sign Up text
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                            );
                          },
                          child: Text.rich(
                            TextSpan(
                              text: 'Don\'t have an account? ',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13.sp,
                                color: Color(0xFF6B6B6B),
                              ),
                              children: [
                                TextSpan(
                                  text: 'Sign Up',
                                  style: TextStyle(
                                    color: Color(0xFFA88143),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        // Bottom star decoration
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(width: 40.w, height: 1, color: const Color(0xFFD6D0C4)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Icon(Icons.star, size: 16.sp, color: Color(0xFFD6D0C4)),
                            ),
                            Container(width: 40.w, height: 1, color: const Color(0xFFD6D0C4)),
                          ],
                        ),
                        SizedBox(height: 16),
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
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: Color(0xFF0A1B28),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, {bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
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
          color: Color(0xFF8A8A8A),
        ),
        filled: true,
        fillColor: const Color(0xFFFFFFFF),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: const BorderSide(color: Color(0xFFEAE6DF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: const BorderSide(color: Color(0xFFA88143)),
        ),
      ),
    );
  }
}
