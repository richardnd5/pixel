import 'package:flutter/material.dart';

class Cell {
  Color color;
  Offset? gridPos;
  bool on;
  int number;
  double? size;

  Cell({
    required this.color,
    this.gridPos,
    required this.on,
    required this.number,
    this.size,
  });
}
