import 'package:flutter/material.dart';
import 'package:pixel/services/canvas_service.dart';
import 'package:provider/provider.dart';
import 'my_painter.dart';

class PixelPage extends StatefulWidget {
  const PixelPage({Key? key}) : super(key: key);

  @override
  _PixelPageState createState() => _PixelPageState();
}

class _PixelPageState extends State<PixelPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Provider.of<CanvasService>(context, listen: false).createBlankCanvas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        ElevatedButton(
          onPressed:
              Provider.of<CanvasService>(context, listen: false).clearCanvas,
          child: Text('Clear'),
        )
      ],
      body: Center(
        child: SafeArea(
          child: Center(
            child: InteractiveViewer(
              constrained: false,
              minScale: 0.01,
              maxScale: 50,
              child: GestureDetector(
                onTapUp: (details) =>
                    Provider.of<CanvasService>(context, listen: false)
                        .tapUp(details.localPosition),
                child: CustomPaint(
                  size: Size(5000, 5000),
                  painter:
                      MyPainter(context.watch<CanvasService>().currentCanvas),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
