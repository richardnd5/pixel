import 'package:flutter/material.dart';
import 'cell.dart';

class CanvasModel {
  List<Cell> cells;
  String name;
  Color cellColor;

  CanvasModel({
    required this.name,
    required this.cells,
    required this.cellColor,
  });

  CanvasModel.clone(CanvasModel canvas)
      : this.cells = canvas.cells
            .map<Cell>((e) => new Cell(
                  color: e.color,
                  gridPos: e.gridPos,
                  on: e.on,
                  number: e.number,
                  size: e.size,
                ))
            .toList(),
        this.name = canvas.name,
        this.cellColor = canvas.cellColor;
}
