import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../home/main_layout_screen.dart';
import '../../core/services/auth_service.dart';
import 'sign_up_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await AuthService.login(email: email, password: password);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result['success']) {
      final String? userName = result['data']?['data']?['user']?['name'];

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => MainLayoutScreen(userName: userName),
        ),
        (route) => false,
      );
    } else {
      final errorMessage = result['message'] ?? 'Login failed';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

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
                        // White box for logo
                        Container(
                          width: 160.w,
                          height: 160.h,
                          decoration: const BoxDecoration(color: Colors.white),
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
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 3.0,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 30.w,
                                    height: 0.5,
                                    color: const Color(0xFFEAE6DF),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4.w,
                                    ),
                                    child: Icon(
                                      Icons.star,
                                      size: 6.sp,
                                      color: const Color(0xFFA88143),
                                    ),
                                  ),
                                  Container(
                                    width: 30.w,
                                    height: 0.5,
                                    color: const Color(0xFFEAE6DF),
                                  ),
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
                        SizedBox(height: 32.h),
                        // Headings
                        Text(
                          'Welcome Back',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0A1B28), // Dark Navy
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.w),
                          child: Text(
                            'Reconnect with your celestial path\nand cosmic insights.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14.sp,
                              fontStyle: FontStyle.italic,
                              color: const Color(0xFF6B6B6B),
                              height: 1.4,
                            ),
                          ),
                        ),
                        SizedBox(height: 32.h),
                        // Email Field
                        _buildLabel('EMAIL ADDRESS'),
                        SizedBox(height: 8.h),
                        _buildTextField('your@email.com', _emailController),

                        SizedBox(height: 20.h),

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
                                    builder: (context) =>
                                        const ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Forgot password?',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFA88143),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        _buildTextField(
                          '••••••••',
                          _passwordController,
                          obscureText: true,
                        ),

                        SizedBox(height: 32.h),

                        // Sign In Button
                        SizedBox(
                          width: double.infinity,
                          height: 52.h,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                0xFF050B14,
                              ), // Very dark navy/black
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? SizedBox(
                                    width: 24.w,
                                    height: 24.w,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
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

                        SizedBox(height: 32.h),
                        // OR CONTINUE WITH
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(color: Color(0xFFEAE6DF)),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Text(
                                'OR CONTINUE WITH',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.0,
                                  color: const Color(0xFF6B6B6B),
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Divider(color: Color(0xFFEAE6DF)),
                            ),
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
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/google.svg',
                                  width: 20.w,
                                  height: 20.h,
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

                        const Spacer(),
                        SizedBox(height: 32.h),
                        // Sign Up text
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const SignUpScreen(),
                              ),
                            );
                          },
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "Don't have an account? ",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13.sp,
                                    color: const Color(0xFF6B6B6B),
                                  ),
                                ),
                                TextSpan(
                                  text: 'Sign up',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFA88143),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 10.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
        color: const Color(0xFF8A8A8A),
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller, {
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFEAE6DF)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14.sp,
          color: const Color(0xFF11141A),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14.sp,
            color: const Color(0xFFB0B0B0),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
        ),
      ),
    );
  }
}
