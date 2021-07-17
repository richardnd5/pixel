import 'package:flutter/material.dart';
import 'package:pixel/my_painter.dart';

class Canvas {
  List<Dot> dots;
  String name;
  Color dotsColor;

  Canvas({
    required this.name,
    required this.dots,
    required this.dotsColor,
  });

  Canvas.clone(Canvas canvas)
      : this.dots = canvas.dots
            .map<Dot>((e) => new Dot(
                  color: e.color,
                  gridPos: e.gridPos,
                  on: e.on,
                  number: e.number,
                  size: e.size,
                ))
            .toList(),
        this.name = canvas.name,
        this.dotsColor = canvas.dotsColor;
}

class CanvasService extends ChangeNotifier {
  Canvas get currentCanvas => _currentCanvas;
  Canvas _currentCanvas =
      Canvas(name: 'noodle', dots: [], dotsColor: Colors.black);
  bool _canvasSaved = false;
  double get squareSize => _squareSize;
  late double _squareSize;

  bool get playingAnimation => _playingAnimation;
  bool _playingAnimation = false;

  bool get loading => _loading;
  bool _loading = false;

  List<Canvas> get savedCanvases => _savedCanvases;
  List<Canvas> _savedCanvases = [];

  bool get saveOnEachChange => _saveOnEachChange;
  bool _saveOnEachChange = true;

  bool get showPreviousFrame => _showPreviousFrame;
  bool _showPreviousFrame = false;

  toggleShowPreviousFrame() {
    _showPreviousFrame = !_showPreviousFrame;
    notifyListeners();
  }

  toggleSaveOnEachChange() {
    _saveOnEachChange = !_saveOnEachChange;
    notifyListeners();
  }

  tapUp(Offset localPosition) => _getDotAtPosition(localPosition);

  _getDotAtPosition(Offset localPosition) {
    var foundDot = _currentCanvas.dots.firstWhere(
        (dot) => tapWithinOffset(localPosition, dot.gridPos!, squareSize),
        orElse: () =>
            Dot(color: Colors.black, gridPos: null, on: false, number: 0));
    if (foundDot.gridPos != null) {
      foundDot.on = !foundDot.on;
      _canvasSaved = false;
      if (saveOnEachChange) saveCurrentCanvas();

      notifyListeners();
    }
  }

  bool tapWithinOffset(Offset tapOffset, Offset offsetToCheck, double radius) =>
      tapOffset.dx - radius <= offsetToCheck.dx &&
      tapOffset.dx + radius >= offsetToCheck.dx &&
      tapOffset.dy - radius <= offsetToCheck.dy &&
      tapOffset.dy + radius >= offsetToCheck.dy;

  createBlankCanvas({Size size = const Size(50, 50), double squareSize = 40}) {
    _loading = true;
    notifyListeners();
    _squareSize = squareSize;
    var count = 0;
    for (var i = 0; i < size.width; i++) {
      for (var v = 0; v < size.height; v++) {
        var xPos = ((squareSize) * i).toDouble() + squareSize;
        var yPos = ((squareSize) * v).toDouble() + squareSize;
        var color = Colors.black;

        Offset gridPos = Offset(xPos, yPos);
        _currentCanvas.dots.add(Dot(
            color: color,
            gridPos: gridPos,
            on: false,
            number: count,
            size: Size(squareSize, squareSize)));
        count++;
      }
    }
    _loading = false;
    notifyListeners();
  }

  clearCanvas() {
    _currentCanvas = Canvas(
      name: 'noodle',
      dots: [],
      dotsColor: Colors.black,
    );
    _canvasSaved = false;
    createBlankCanvas();
    notifyListeners();
  }

  clearAnimation() {
    _currentCanvas = Canvas(
      name: 'noodle',
      dots: [],
      dotsColor: Colors.black,
    );
    _canvasSaved = false;
    _savedCanvases = [];
    createBlankCanvas();
    notifyListeners();
  }

  bool saveCurrentCanvas() {
    if (!_canvasSaved && _currentCanvas.dots.isNotEmpty) {
      _canvasSaved = true;

      var secondList = new Canvas.clone(_currentCanvas);
      savedCanvases.add(secondList);
      return true;
    }
    return false;
  }

  loadCanvas(List<Dot> canvas) {
    _canvasSaved = false;
    notifyListeners();
  }

  playArrayOfCanvases(
      {Duration frameRate = const Duration(milliseconds: 100)}) async {
    _playingAnimation = true;
    for (var canvas in _savedCanvases) {
      _currentCanvas = canvas;
      notifyListeners();
      await Future.delayed(frameRate);
    }
    _playingAnimation = false;
  }
}
