import 'package:flutter/material.dart';
import 'my_painter.dart';

class PixelPage extends StatefulWidget {
  const PixelPage({Key? key}) : super(key: key);

  @override
  _PixelPageState createState() => _PixelPageState();
}

class _PixelPageState extends State<PixelPage> {
  List<Dot> dots = [];
  final double circleSize = 30;
  @override
  void initState() {
    super.initState();
    var count = 0;
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      for (var i = 0; i < 100; i++) {
        for (var v = 0; v < 200; v++) {
          var xPos = ((circleSize) * i).toDouble() + circleSize;
          var yPos = ((circleSize) * v).toDouble() + circleSize;
          var color = Colors.black;

          Offset gridPos = Offset(xPos, yPos);
          dots.add(Dot(
              color: color,
              gridPos: gridPos,
              on: false,
              number: count,
              size: Size(circleSize, circleSize)));
          count++;
        }
      }
    });
  }

  _tapUp(TapUpDetails details) {
    getDotAtPosition(details);
  }

  getDotAtPosition(TapUpDetails details) {
    var foundDot = dots.firstWhere(
        (dot) =>
            tapWithinOffset(details.localPosition, dot.gridPos!, circleSize),
        orElse: () =>
            Dot(color: Colors.black, gridPos: null, on: false, number: 0));
    if (foundDot.gridPos != null) {
      setState(() {
        foundDot.on = !foundDot.on;
      });
    }
  }

  bool tapWithinOffset(Offset tapOffset, Offset offsetToCheck, double radius) =>
      tapOffset.dx - radius <= offsetToCheck.dx &&
      tapOffset.dx + radius >= offsetToCheck.dx &&
      tapOffset.dy - radius <= offsetToCheck.dy &&
      tapOffset.dy + radius >= offsetToCheck.dy;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        Text('Button 1'),
        Text('Button 2'),
      ],
      body: Center(
        child: SafeArea(
          child: Center(
            child: InteractiveViewer(
              constrained: false,
              minScale: 0.001,
              maxScale: 50,
              child: GestureDetector(
                onTapUp: (details) => _tapUp(details),
                child: CustomPaint(
                  size: Size(10000, 10000),
                  painter: MyPainter(dots),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
