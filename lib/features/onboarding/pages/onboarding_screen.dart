import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingScreen extends StatelessWidget {
  final VoidCallback onNext;
  const OnboardingScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFAF9F5),
      child: Column(
        children: [
          const SizedBox(height: 80),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'DIGITAL KUNDALI',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 20,
                letterSpacing: 3,
                fontWeight: FontWeight.w500,
                color: Color(0xFF11141A),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF9F8F3),
              borderRadius: BorderRadius.circular(16),
              border: const Border(
                top: BorderSide(color: Color(0xFFEAE6DF)),
                bottom: BorderSide(color: Color(0xFFEAE6DF)),
              ),
            ),
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                color: const Color(0xFFFAF9F5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEAE6DF)),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/onboarding.svg',
                width: 180,
                height: 180,
              ),
            ),
          ),
          const SizedBox(height: 40),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Astronomical Precision',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF11141A),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Powered by our own planetary engine using\nreal orbital mechanics for unmatched\naccuracy.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1.6,
                color: Color(0xFF6B6B6B),
              ),
            ),
          ),
          const SizedBox(
            height: 110,
          ), // Increased spacing to push dots down a little
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              4,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color:
                      index ==
                          1 // Changed to highlight the second page
                      ? const Color(0xFF947239)
                      : const Color(0xFFD6D6D6),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A0A0C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'NEXT',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 16),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onNext,
            child: const Text(
              'SKIP',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
                color: Color(0xFF6B6B6B),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
