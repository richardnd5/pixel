import 'package:flutter/material.dart';
import 'package:pixel/models/cell.dart';

class CanvasPainter extends CustomPainter {
  const CanvasPainter(
    this.cells, {
    this.gridToggle = false,
    this.gridColor = Colors.blue,
  });

  final List<Cell> cells;
  final bool gridToggle;
  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    var gridWidth = 0.1;
    cells.asMap().forEach((index, cell) {
      var paint = Paint();
      paint.strokeWidth = gridWidth;
      paint.color = cell.on ? cell.color : Colors.transparent;
      paint.style = PaintingStyle.fill;

      Rect rect = Offset(cell.gridPos!.dx, cell.gridPos!.dy) &
          Size(cell.size!, cell.size!);
      canvas.drawRect(rect, paint);

      if (gridToggle) {
        var gridStroke = Paint();
        gridStroke.strokeWidth = gridWidth;
        gridStroke.color = gridColor;
        gridStroke.style = PaintingStyle.stroke;
        canvas.drawRect(rect, gridStroke);
      }
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
