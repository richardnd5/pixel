import 'package:flutter/material.dart';

class Dot {
  Color color;
  Offset? gridPos;
  bool on;
  int number;
  Size? size;

  Dot({
    required this.color,
    this.gridPos,
    required this.on,
    required this.number,
    this.size,
  });
}

class MyPainter extends CustomPainter {
  const MyPainter(this.dots);

  // final double circleSize = 20;
  final List<Dot> dots;

  @override
  void paint(Canvas canvas, Size size) {
    dots.asMap().forEach((index, dot) {
      var paint = Paint();
      paint.strokeWidth = 2;
      paint.color = dot.on ? dot.color : Colors.black;
      paint.style = dot.on ? PaintingStyle.fill : PaintingStyle.stroke;
      // canvas.drawCircle(
      //     Offset(dot.gridPos!.dx, dot.gridPos!.dy), circleSize, paint);

      Rect rect = Offset(dot.gridPos!.dx, dot.gridPos!.dy) & dot.size!;
      canvas.drawRect(rect, paint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
