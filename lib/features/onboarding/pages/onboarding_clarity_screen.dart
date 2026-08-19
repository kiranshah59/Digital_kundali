import 'package:flutter/material.dart';
import '../widgets/geometric_illustration_painter.dart';

class OnboardingClarityScreen extends StatelessWidget {
  const OnboardingClarityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFAF9F5),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 60),
          Row(
            children: [
              const Icon(Icons.copy, size: 14, color: Color(0xFF8A8A8A)),
              const SizedBox(width: 6),
              const Text(
                'Onboarding: Clarity',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: Color(0xFF8A8A8A),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              const Text(
                'Skip',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: Color(0xFF11141A),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: 240,
            height: 240,
            child: CustomPaint(painter: GeometricIllustrationPainter()),
          ),
          const SizedBox(height: 40),
          _buildInfoCard(
            true,
            'CAREER PATH',
            'You are naturally drawn to leadership roles requiring deep analytical focus and strategic planning.',
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            false,
            'PERSONAL GROWTH',
            'The current planetary shift suggests a period of internal reflection and creative renewal.',
          ),
          const Spacer(),
          const Text(
            'Read with Clarity',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: Color(0xFF11141A),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No mystical jargon. Just plain English\nreadings grounded in your actual chart\ndata.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              height: 1.6,
              color: Color(0xFF6B6B6B),
            ),
          ),
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDot(false),
              _buildDot(false),
              _buildDot(false),
              _buildDot(true),
            ],
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A0A0C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'NEXT',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildInfoCard(bool isGold, String label, String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEAE6DF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isGold
                      ? const Color(0xFFA88143)
                      : const Color(0xFFB0B0B0),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: isGold
                      ? const Color(0xFFA88143)
                      : const Color(0xFF8A8A8A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              height: 1.5,
              color: Color(0xFF4A4A4A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFA88143) : const Color(0xFFD6D6D6),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
