import 'package:flutter/material.dart';
import 'package:pixel/my_painter.dart';

class CanvasService extends ChangeNotifier {
  List<Dot> get currentCanvas => _currentCanvas;
  List<Dot> _currentCanvas = [];
  double get squareSize => _squareSize;
  late double _squareSize;

  bool get playingAnimation => _playingAnimation;
  bool _playingAnimation = false;

  bool get loading => _loading;
  bool _loading = false;

  List<List<Dot>> get savedCanvases => _savedCanvases;
  List<List<Dot>> _savedCanvases = [];

  tapUp(Offset localPosition) => _getDotAtPosition(localPosition);

  _getDotAtPosition(Offset localPosition) {
    var foundDot = _currentCanvas.firstWhere(
        (dot) => tapWithinOffset(localPosition, dot.gridPos!, squareSize),
        orElse: () =>
            Dot(color: Colors.black, gridPos: null, on: false, number: 0));
    if (foundDot.gridPos != null) {
      foundDot.on = !foundDot.on;
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
        _currentCanvas.add(Dot(
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
    _currentCanvas = [];
    createBlankCanvas();
    notifyListeners();
  }

  saveCanvas(List<Dot> canvas) {
    savedCanvases.add(canvas);
  }

  loadCanvas(List<Dot> canvas) {
    notifyListeners();
  }

  playArrayOfCanvases(Duration frameRate, List<List<Dot>> frames) {
    _playingAnimation = true;
    frames.forEach((canvas) async {
      _currentCanvas = canvas;
      await Future.delayed(frameRate);
      notifyListeners();
    });
    _playingAnimation = false;
  }
}
