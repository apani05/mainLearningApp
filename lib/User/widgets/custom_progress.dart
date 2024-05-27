import 'dart:math';
import 'package:flutter/material.dart';

class CustomCircularProgressPainter extends CustomPainter {
  final double progress1;
  final double progress2;
  final Color color1;
  final Color color2;

  CustomCircularProgressPainter({required this.progress1, required this.progress2, required this.color1, required this.color2});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;


    paint.color = color1;
    double radius1 = min(size.width / 2, size.height / 2) - paint.strokeWidth / 2;
    double angle1 = 2 * pi * progress1;
    Rect rect1 = Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: radius1);
    canvas.drawArc(rect1, -pi / 2, angle1, false, paint);

    paint.color = color2;
    double radius2 = radius1 - 20;
    double angle2 = 2 * pi * progress2;
    Rect rect2 = Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: radius2);
    canvas.drawArc(rect2, -pi / 2, angle2, false, paint);
  }

  @override
  bool shouldRepaint(CustomCircularProgressPainter oldDelegate) {
    return oldDelegate.progress1 != progress1 || oldDelegate.progress2 != progress2;
  }
}
