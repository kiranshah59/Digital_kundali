import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatelessWidget {
  final VoidCallback onNext;

  const SplashScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFAF9F5),
      child: Column(
        children: [
          const Spacer(flex: 3),
          Container(
            width: 250,
            height: 230,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/splash.svg', width: 100, height: 100),
                const SizedBox(height: 16),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 3.5,
                    ),
                    children: [
                      TextSpan(
                        text: 'DIGITAL',
                        style: TextStyle(color: Color(0xFF11141A)),
                      ),
                      TextSpan(
                        text: 'KUNDALI',
                        style: TextStyle(color: Color(0xFFA88143)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'YOUR BIRTH CHART, READ WITH CLARITY',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 6,
                    letterSpacing: 1.5,
                    color: Color(0xFF8A8A8A),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(width: 250, height: 1, color: const Color(0xFFEAE6DF)),
          const SizedBox(height: 24),
          const Text(
            'Your birth chart, read with clarity.',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontStyle: FontStyle.italic,
              fontSize: 20,
              color: Color(0xFF4A4A4A),
            ),
          ),
          const Spacer(flex: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 40, height: 1, color: const Color(0xFFDFD8CB)),
              const SizedBox(width: 14),
              const Text(
                'CALCULATED WITH PRECISION',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  color: Color(0xFFC2A878),
                ),
              ),
              const SizedBox(width: 14),
              Container(width: 40, height: 1, color: const Color(0xFFDFD8CB)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Color(0xFFD1D1D1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
