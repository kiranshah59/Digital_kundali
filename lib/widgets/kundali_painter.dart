import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KundaliPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFEAE6DF)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;

    // Outer square
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), paint);

    // Diagonals (X)
    canvas.drawLine(const Offset(0, 0), Offset(w, h), paint);
    canvas.drawLine(Offset(0, h), Offset(w, 0), paint);

    // Inner diamond (Rhombus joining midpoints)
    final path = Path();
    path.moveTo(w / 2, 0); // Top mid
    path.lineTo(w, h / 2); // Right mid
    path.lineTo(w / 2, h); // Bottom mid
    path.lineTo(0, h / 2); // Left mid
    path.close();
    canvas.drawPath(path, paint);

    // Function to draw text at a specific center point
    void drawText(String text, Offset center, {bool isNumber = false}) {
      final textSpan = TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: isNumber ? 'Inter' : 'Georgia',
          fontSize: isNumber ? 10.sp : 12.sp,
          fontWeight: isNumber ? FontWeight.w500 : FontWeight.w600,
          color: isNumber ? const Color(0xFFA88143) : const Color(0xFF11141A),
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2),
      );
    }

    // Draw House Numbers (golden)
    drawText('5', Offset(w / 2, h * 0.08), isNumber: true); // Top diamond top
    drawText('2', Offset(w * 0.92, h / 2), isNumber: true); // Right diamond right
    drawText('11', Offset(w / 2, h * 0.92), isNumber: true); // Bottom diamond bottom
    drawText('8', Offset(w * 0.08, h / 2), isNumber: true); // Left diamond left
    
    // Draw Planets (black bold)
    drawText('Su, Me', Offset(w * 0.25, h * 0.25)); // Top Left house
    drawText('Ma', Offset(w * 0.75, h * 0.25)); // Top Right house
    drawText('Ve', Offset(w * 0.25, h * 0.75)); // Bottom Left house
    drawText('Mo', Offset(w * 0.75, h * 0.75)); // Bottom Right house
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
