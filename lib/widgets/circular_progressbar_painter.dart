import 'dart:math';

import 'package:flutter/material.dart';

class CircularProgressBarPainter extends CustomPainter {
  final Color lineColor;
  final Color completeColor;
  final double completePercent;
  final double width;

  const CircularProgressBarPainter({
    @required this.lineColor,
    @required this.completeColor,
    @required this.completePercent,
    @required this.width,
  })  : assert(lineColor != null),
        assert(completeColor != null),
        assert(completePercent != null),
        assert(width != null);

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = new Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width / 2;

    Paint complete = new Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    Offset center = new Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    canvas.drawCircle(center, radius, line);

    double arcAngle = 2 * pi * (completePercent / 100);
    canvas.drawArc(new Rect.fromCircle(center: center, radius: radius), -pi / 2,
        arcAngle, false, complete);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
