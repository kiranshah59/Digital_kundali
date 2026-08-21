import 'package:flutter/material.dart';

class GeometricIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paintThin = Paint()
      ..color = const Color(0xFFEAE6DF)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    final Paint paintGold = Paint()
      ..color = const Color(0xFFA88143)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    final Paint paintGoldFill = Paint()
      ..color = const Color(0xFFA88143)
      ..style = PaintingStyle.fill;

    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double w = size.width;
    final double h = size.height;

    final double sqSize = w * 0.4;
    final Rect centerRect = Rect.fromCenter(center: Offset(cx, cy), width: sqSize, height: sqSize);
    
    final Paint paintBoxFill = Paint()
      ..color = const Color(0xFFF5F2EA)
      ..style = PaintingStyle.fill;
      
    canvas.drawRect(centerRect, paintBoxFill);

    final Path diamond = Path()
      ..moveTo(cx, 0)
      ..lineTo(w, cy)
      ..lineTo(cx, h)
      ..lineTo(0, cy)
      ..close();
    canvas.drawPath(diamond, paintThin);

    canvas.drawLine(Offset(0, cy), Offset(w, cy), paintThin);
    canvas.drawLine(Offset(cx, 0), Offset(cx, h), paintThin);
    canvas.drawLine(
      Offset(cx / 2, cy / 2),
      Offset(w - cx / 2, h - cy / 2),
      paintThin,
    );
    canvas.drawLine(
      Offset(cx / 2, h - cy / 2),
      Offset(w - cx / 2, cy / 2),
      paintThin,
    );

    canvas.drawRect(centerRect, paintGold);

    canvas.drawCircle(Offset(cx, cy), 12, paintGoldFill);

    final Paint paintWhite = Paint()
      ..color = const Color(0xFFFAF9F5)
      ..style = PaintingStyle.fill;
    final Path star = Path()
      ..moveTo(cx, cy - 8)
      ..quadraticBezierTo(cx, cy, cx + 8, cy)
      ..quadraticBezierTo(cx, cy, cx, cy + 8)
      ..quadraticBezierTo(cx, cy, cx - 8, cy)
      ..quadraticBezierTo(cx, cy, cx, cy - 8)
      ..close();
    canvas.drawPath(star, paintWhite);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
