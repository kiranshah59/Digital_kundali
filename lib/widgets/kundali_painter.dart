import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/nepali_kundali_model.dart';

class KundaliPainter extends CustomPainter {
  final NepaliKundaliModel? kundaliData;
  final bool showEnglish;

  KundaliPainter({this.kundaliData, this.showEnglish = true});

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

    if (kundaliData == null || kundaliData!.houses.isEmpty) {
      // Fallback/Loading state
      drawText('...', Offset(w / 2, h / 2));
      return;
    }

    // Map the 12 houses to their visual positions
    // In North Indian style:
    // House 1 is top diamond. Houses go counter-clockwise.
    final housePositions = {
      1: Offset(w / 2, h * 0.25),
      2: Offset(w * 0.25, h * 0.08),
      3: Offset(w * 0.08, h * 0.25),
      4: Offset(w * 0.25, h / 2),
      5: Offset(w * 0.08, h * 0.75),
      6: Offset(w * 0.25, h * 0.92),
      7: Offset(w / 2, h * 0.75),
      8: Offset(w * 0.75, h * 0.92),
      9: Offset(w * 0.92, h * 0.75),
      10: Offset(w * 0.75, h / 2),
      11: Offset(w * 0.92, h * 0.25),
      12: Offset(w * 0.75, h * 0.08),
    };

    final numberPositions = {
      1: Offset(w / 2, h * 0.08),
      2: Offset(w * 0.35, h * 0.15),
      3: Offset(w * 0.15, h * 0.35),
      4: Offset(w * 0.35, h / 2),
      5: Offset(w * 0.15, h * 0.65),
      6: Offset(w * 0.35, h * 0.85),
      7: Offset(w / 2, h * 0.92),
      8: Offset(w * 0.65, h * 0.85),
      9: Offset(w * 0.85, h * 0.65),
      10: Offset(w * 0.65, h / 2),
      11: Offset(w * 0.85, h * 0.35),
      12: Offset(w * 0.65, h * 0.15),
    };

    for (var house in kundaliData!.houses) {
      int houseNum = house.house;
      if (houseNum >= 1 && houseNum <= 12) {
        // Draw House Number
        // If showEnglish is true, display house number (as a string).
        // The API returns sign_devanagari, which in Kundali shows the sign number in that house.
        // Actually, the number written in the house is the Zodiac Sign number. 
        // We will just use the sign_devanagari as it usually represents the sign number in North Indian chart.
        // Alternatively we can use the English sign name or a mapped number.
        // For simplicity, let's just use what the API gives.
        String signLabel = showEnglish ? house.signEn.substring(0, 3).toUpperCase() : house.signDevanagari;
        drawText(signLabel, numberPositions[houseNum]!, isNumber: true);

        // Draw Planets
        if (house.planets.isNotEmpty) {
          String planetsStr = house.planets.map((p) {
            String pName = showEnglish ? p.key.substring(0, 1).toUpperCase() + p.key.substring(1, 2) : p.nameDevanagari;
            return pName;
          }).join(', ');
          drawText(planetsStr, housePositions[houseNum]!);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant KundaliPainter oldDelegate) {
    return oldDelegate.kundaliData != kundaliData || oldDelegate.showEnglish != showEnglish;
  }
}
