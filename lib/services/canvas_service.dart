import 'package:flutter/material.dart';
import 'package:pixel/models/cell.dart';

import 'canvas_helper.dart';

class CanvasService extends ChangeNotifier {
  Size get gridDimensions => _gridDimensions;
  Size _gridDimensions = Size(50, 50);

  double get cellSize => _cellSize;
  late double _cellSize = 40;

  Size get screenSize => _screenSize;
  late Size _screenSize;

  double get gridLineWidth => _gridLineWidth;
  double _gridLineWidth = 0.1;
  Color gridLineColor = Colors.lightBlue;

  int currentSelectedIndex = 0;

  List<Cell> get currentScreen => _currentScreen;
  List<Cell> _currentScreen = [];

  List<Cell> _currentCells = [];
  List<Cell> _previousCells = [];

  List<List<Cell>> _canvasAnimation = [];

  bool get playingAnimation => _playingAnimation;
  bool _playingAnimation = false;

  bool get loading => _loading;
  bool _loading = false;

  bool get canvasSaved => _canvasSaved;
  bool _canvasSaved = false;

  bool get saveOnEachChange => _saveOnEachChange;
  bool _saveOnEachChange = false;

  bool get showPreviousFrame => _showPreviousFrame;
  bool _showPreviousFrame = true;

  bool get grid => _grid;
  bool _grid = true;

  startCanvasService(Size gridDimensions, Size screenSize) {
    resetCanvasToScreenDimensions(gridDimensions, screenSize);
    _canvasAnimation.add(_currentCells);
  }

  resetCanvasToScreenDimensions(Size gridDimensions, Size screenSize) {
    clearCanvas();
    _screenSize = screenSize;
    _gridDimensions = gridDimensions;
    _cellSize = (screenSize.width / gridDimensions.width);

    var count = 0;
    for (var i = 0; i < _gridDimensions.width; i++) {
      for (var v = 0; v < _gridDimensions.height; v++) {
        var xPos = i.toDouble();
        var yPos = v.toDouble();
        var color = Colors.black;

        Offset gridPos = Offset(xPos, yPos);
        _currentCells.add(
          Cell(
            color: color,
            gridPos: gridPos,
            on: false,
            number: count,
            size: _cellSize,
          ),
        );
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

  _getCellAtPosition(Offset localPosition) {
    var foundCell = _currentCells.firstWhere(
        (cell) => tapWithinOffset(
            localPosition,
            Offset(cell.gridPos!.dx * cellSize, cell.gridPos!.dy * cellSize),
            cellSize),
        orElse: () =>
            Cell(color: Colors.black, gridPos: null, on: false, number: 0));
    if (foundCell.gridPos != null) {
      foundCell.on = !foundCell.on;
      _canvasSaved = false;
      saveToCurrentSlot();
      if (saveOnEachChange) saveAndIncrement();
      _renderScreen();
      notifyListeners();
    }
  }

  loadBlankCanvas() {
    resetCanvasToScreenDimensions(gridDimensions, screenSize);
  }

  drawPreviousCanvas() {
    _previousCells = _canvasAnimation[currentSelectedIndex - 1]
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
    _currentScreen = [];
    notifyListeners();
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

  bool saveAndIncrement() {
    if (!_canvasSaved && _currentCells.isNotEmpty) {
      addCurrentCellsToAnimationArray();
      _canvasSaved = true;
      makeNewFrame();
      return true;
    }
    return false;
  }

  saveToCurrentSlot() {
    _canvasAnimation[currentSelectedIndex] = _currentCells;
  }

  makeNewFrame() {
    currentSelectedIndex += 1;
    clearCanvas();
    loadBlankCanvas();
    _renderScreen();
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
    _canvasSaved = true;
  }

  goBackAFrame() {
    saveToCurrentSlot();
    if (_canvasAnimation.isNotEmpty && currentSelectedIndex > 0) {
      currentSelectedIndex -= 1;
      clearCanvas();
      _currentCells = _canvasAnimation[currentSelectedIndex];
      _renderScreen();
      if (currentSelectedIndex - 1 > 0) {
        _previousCells = _canvasAnimation[currentSelectedIndex - 1];
        drawPreviousCanvas();
        _renderScreen();
      }
    }
  }

  goForwardAFrame() {
    saveToCurrentSlot();
    if (_canvasAnimation.length - 1 > currentSelectedIndex) {
      currentSelectedIndex += 1;
      _currentCells = _canvasAnimation[currentSelectedIndex];
      if (currentSelectedIndex > 0) {
        _previousCells = _canvasAnimation[currentSelectedIndex - 1];
        drawPreviousCanvas();
      }
      _renderScreen();
    }
  }

  addCurrentCellsToAnimationArray() {
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
  }
}
