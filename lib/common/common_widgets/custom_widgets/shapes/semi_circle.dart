import 'package:flutter/material.dart';
import 'dart:math' as math;

class Semicircle extends StatelessWidget {
  const Semicircle({super.key, this.color, this.rotation});

  final Color? color;
  final int? rotation;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: rotation ?? 0,
      child:  CustomPaint(
        painter: MyPainter(Colors.white),
        size: Size(40, 38),
      ),
    );
  }
}
// This is the Painter class
class MyPainter extends CustomPainter {

  Color color;

  MyPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: size.height,
        width: size.width,
      ),
      math.pi,
      math.pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
