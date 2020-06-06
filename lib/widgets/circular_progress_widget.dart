import 'dart:math';

import 'package:flutter/material.dart';

class CircularProgress extends CustomPainter{

  double currentProgress;

  Color weightColor;

  CircularProgress(this.currentProgress, this.weightColor);

  @override
  void paint(Canvas canvas, Size size) {
    Paint _outerCircle = Paint()
    ..strokeWidth = 10
    ..color = Colors.grey[700]
    ..style = PaintingStyle.stroke;

    Paint _completeArc = Paint()
    ..strokeWidth = 10
    ..color = weightColor
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width/2, size.height/2);
    double radius = min(size.width/2, size.height/2) - 10;

    canvas.drawCircle(center, radius, _outerCircle);

    double angle = 2 * pi * (currentProgress/50);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi/2, angle, false, _completeArc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}