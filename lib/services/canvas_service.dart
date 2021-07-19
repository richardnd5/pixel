import 'package:flutter/material.dart';
import 'package:pixel/models/canvas_model.dart';
import 'package:pixel/models/cell.dart';

import 'canvas_helper.dart';

class CanvasService extends ChangeNotifier {
  List<Cell> get currentScreen => _currentScreen;
  List<Cell> _currentScreen = [];

  List<Cell> _currentCells = [];
  List<Cell> _previousCells = [];

  bool get playingAnimation => _playingAnimation;
  bool _playingAnimation = false;

  bool get loading => _loading;
  bool _loading = false;

  bool get canvasSaved => _canvasSaved;
  bool _canvasSaved = false;

  List<List<Cell>> _canvasAnimation = [];

  bool get saveOnEachChange => _saveOnEachChange;
  bool _saveOnEachChange = false;

  bool get showPreviousFrame => _showPreviousFrame;
  bool _showPreviousFrame = true;

  bool get grid => _grid;
  bool _grid = true;

  Color gridColor = Colors.lightBlue;

  Size get canvasSize => _canvasSize;
  Size _canvasSize = Size(2, 2);

  double get cellSize => _cellSize;
  late double _cellSize = 40;

  setCanvasSize(Size size, {double? squareSize}) {
    clearCanvas();
    _canvasSize = size;
    _cellSize = squareSize ?? _cellSize;

    var count = 0;
    for (var i = 0; i < _canvasSize.width; i++) {
      for (var v = 0; v < _canvasSize.height; v++) {
        var xPos = ((_cellSize) * i).toDouble() + _cellSize;
        var yPos = ((_cellSize) * v).toDouble() + _cellSize;
        var color = Colors.black;

        Offset gridPos = Offset(xPos, yPos);
        _currentCells.add(Cell(
            color: color,
            gridPos: gridPos,
            on: false,
            number: count,
            size: _cellSize));
        count++;
      }
    }
    _renderScreen();
  }

  toggleGrid() {
    _grid = !_grid;
    notifyListeners();
  }

  toggleShowPreviousFrame() {
    _showPreviousFrame = !_showPreviousFrame;
    notifyListeners();
  }

  toggleSaveOnEachChange() {
    _saveOnEachChange = !_saveOnEachChange;
    notifyListeners();
  }

  checkTapPosition(Offset localPosition) => _getCellAtPosition(localPosition);

  startCanvas() {
    loadBlankCanvas();
    _renderScreen();
  }

  _getCellAtPosition(Offset localPosition) {
    var foundCell = _currentCells.firstWhere(
        (cell) => tapWithinOffset(localPosition, cell.gridPos!, cellSize),
        orElse: () =>
            Cell(color: Colors.black, gridPos: null, on: false, number: 0));
    if (foundCell.gridPos != null) {
      foundCell.on = !foundCell.on;
      _canvasSaved = false;
      if (saveOnEachChange) saveCurrentCanvas();
      _renderScreen();
      notifyListeners();
    }
  }

  loadBlankCanvas() {
    _loading = true;
    notifyListeners();
    _cellSize = cellSize;
    var count = 0;
    for (var i = 0; i < _canvasSize.width; i++) {
      for (var v = 0; v < _canvasSize.height; v++) {
        var xPos = ((cellSize) * i).toDouble() + cellSize;
        var yPos = ((cellSize) * v).toDouble() + cellSize;
        var color = Colors.black;

        Offset gridPos = Offset(xPos, yPos);
        _currentCells.add(Cell(
            color: color,
            gridPos: gridPos,
            on: false,
            number: count,
            size: cellSize));
        count++;
      }
    }
    _loading = false;
  }

  drawPreviousCanvas() {
    _previousCells = _canvasAnimation[_canvasAnimation.length - 1]
        .map(
          (e) => Cell(
            color: e.color.withOpacity(0.3),
            gridPos: e.gridPos,
            on: e.on,
            number: e.number,
            size: e.size,
          ),
        )
        .toList();
    _currentScreen.addAll(_previousCells);
    notifyListeners();
  }

  _renderScreen() {
    _currentScreen = [
      ..._currentCells,
      if (showPreviousFrame) ..._previousCells
    ];
    notifyListeners();
  }

  clearCanvas() {
    _currentCells = [];
    _previousCells = [];
  }

  clearAnimation() {
    _currentCells = [];
    _canvasSaved = false;
    _canvasAnimation = [];
    _previousCells = [];
    loadBlankCanvas();
    _renderScreen();
    notifyListeners();
  }

  bool saveCurrentCanvas() {
    if (!_canvasSaved && _currentCells.isNotEmpty) {
      _canvasSaved = true;

      final List<Cell> _secondList = _currentCells
          .map<Cell>((e) => new Cell(
                color: e.color,
                gridPos: e.gridPos,
                on: e.on,
                number: e.number,
                size: e.size,
              ))
          .toList();

      _canvasAnimation.add(_secondList);
      clearCanvas();
      loadBlankCanvas();
      _renderScreen();
      return true;
    }
    return false;
  }

  playArrayOfCanvases({
    Duration frameRate = const Duration(milliseconds: 100),
  }) async {
    _playingAnimation = true;
    bool previousValue = _showPreviousFrame;
    _showPreviousFrame = false;
    for (var canvas in _canvasAnimation) {
      _currentCells = canvas;
      _renderScreen();
      await Future.delayed(frameRate);
    }
    _playingAnimation = false;
    _showPreviousFrame = previousValue;
  }
}
