import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../features/kundali/models/chart_model.dart';
import '../features/kundali/models/nepali_kundali_model.dart';

class KundaliPainter extends CustomPainter {
  final ChartModel? chartModel;
  final NepaliKundaliModel? nepaliModel;
  final bool showEnglish;

  KundaliPainter({this.chartModel, this.nepaliModel, this.showEnglish = true});

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
    void drawText(String text, Offset center, {bool isNumber = false, bool isDevanagari = false}) {
      final textSpan = TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: isDevanagari ? null : (isNumber ? 'Inter' : 'Georgia'),
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

    if (chartModel == null || chartModel!.chartData.houses.isEmpty) {
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

    // Translation maps for Nepali
    final Map<String, String> devanagariNumbers = {
      'Aries': '१', 'Taurus': '२', 'Gemini': '३', 'Cancer': '४',
      'Leo': '५', 'Virgo': '६', 'Libra': '७', 'Scorpio': '८',
      'Sagittarius': '९', 'Capricorn': '१०', 'Aquarius': '११', 'Pisces': '१२'
    };

    final Map<String, String> devanagariPlanets = {
      'Sun': 'सूर्य', 'Moon': 'चन्द्र', 'Mars': 'मंगल', 'Mercury': 'बुध',
      'Jupiter': 'गुरु', 'Venus': 'शुक्र', 'Saturn': 'शनि', 'Rahu': 'राहु', 'Ketu': 'केतु'
    };

    // Group planets by house
    final Map<int, List<String>> planetsByHouse = {};
    chartModel!.chartData.planets.forEach((planetName, planetData) {
      if (!planetsByHouse.containsKey(planetData.house)) {
        planetsByHouse[planetData.house] = [];
      }
      String pName = planetName.substring(0, 1).toUpperCase() + planetName.substring(1).toLowerCase();
      
      if (!showEnglish) {
        pName = devanagariPlanets[pName] ?? pName;
      } else {
        // Abbreviate for English (e.g., Sun -> Su, Venus -> Ve)
        pName = pName.substring(0, 2);
      }
      
      planetsByHouse[planetData.house]!.add(pName);
    });

    for (var house in chartModel!.chartData.houses) {
      int houseNum = house.house;
      if (houseNum >= 1 && houseNum <= 12) {
        // Draw House Number/Sign
        String signLabel;
        if (showEnglish) {
          signLabel = house.sign.substring(0, 3).toUpperCase();
        } else {
          // Find the capitalized sign name to match map (e.g., "leo" -> "Leo")
          String capitalizedSign = house.sign.substring(0, 1).toUpperCase() + house.sign.substring(1).toLowerCase();
          signLabel = devanagariNumbers[capitalizedSign] ?? house.sign;
        }
        
        drawText(signLabel, numberPositions[houseNum]!, isNumber: true, isDevanagari: !showEnglish);

        // Draw Planets
        if (planetsByHouse.containsKey(houseNum)) {
          String planetsStr = planetsByHouse[houseNum]!.join(', ');
          drawText(planetsStr, housePositions[houseNum]!, isDevanagari: !showEnglish);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant KundaliPainter oldDelegate) {
    return oldDelegate.chartModel != chartModel || oldDelegate.showEnglish != showEnglish;
  }
}
