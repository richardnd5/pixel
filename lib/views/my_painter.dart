import 'package:flutter/material.dart';
import 'package:pixel/models/cell.dart';

class CanvasPainter extends CustomPainter {
  const CanvasPainter(
    this.cells, {
    required this.cellSize,
    this.gridLineWidth = 0.2,
    this.gridToggle = false,
    this.gridColor = Colors.blue,
    required this.gridDimensions,
  });

  final List<Cell> cells;
  final double cellSize;
  final bool gridToggle;
  final Color gridColor;
  final double gridLineWidth;
  final Size gridDimensions;

  @override
  void paint(Canvas canvas, Size size) {
    cells.asMap().forEach((index, cell) {
      var paint = Paint();
      paint.strokeWidth = gridLineWidth;
      paint.color = cell.on ? cell.color : Colors.transparent;
      paint.style = PaintingStyle.fill;

      Rect rect =
          Offset(cell.gridPos!.dx * cell.size!, cell.gridPos!.dy * cell.size!) &
              Size(cell.size!, cell.size!);

      canvas.drawRect(rect, paint);

      if (gridToggle) {
        var gridStroke = Paint();
        gridStroke.strokeWidth = gridLineWidth;
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
