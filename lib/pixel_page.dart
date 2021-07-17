import 'package:flutter/material.dart';
import 'package:pixel/services/canvas_service.dart';
import 'package:pixel/show_snack_bar.dart';
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

  savePressed() {
    ScaffoldMessenger.of(context).clearSnackBars();
    showSnackBar(
        context,
        Provider.of<CanvasService>(context, listen: false).saveCurrentCanvas()
            ? 'Canvas Saved'
            : 'Already Saved');
  }

  saveOnChangeToggle() {
    Provider.of<CanvasService>(context, listen: false).toggleSaveOnEachChange();
  }

  toggleShowPreviousFrame() {
    Provider.of<CanvasService>(context, listen: false)
        .toggleShowPreviousFrame();
  }

  playPressed() {
    ScaffoldMessenger.of(context).clearSnackBars();
    Provider.of<CanvasService>(context, listen: false).playArrayOfCanvases();
  }

  clearAnimationPressed() {
    ScaffoldMessenger.of(context).clearSnackBars();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Are you sure you want to clear the animation?'),
        actions: [
          TextButton(
            child: Text('No'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              Provider.of<CanvasService>(context, listen: false)
                  .clearAnimation();
              showSnackBar(context, 'Animation Cleared');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: SafeArea(
        child: Scaffold(
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  title: Row(
                    children: [
                      Switch(
                        value: context.watch<CanvasService>().saveOnEachChange,
                        onChanged: (_) => saveOnChangeToggle(),
                      ),
                      Text('Save On Change'),
                    ],
                  ),
                ),
                ListTile(
                  title: Row(
                    children: [
                      Switch(
                        value: context.watch<CanvasService>().showPreviousFrame,
                        onChanged: (_) => toggleShowPreviousFrame(),
                      ),
                      Text('Show Previous Frame'),
                    ],
                  ),
                ),
                ListTile(
                  title: Text('Clear Animation'),
                  leading: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => Colors.red)),
                    onPressed: clearAnimationPressed,
                    child: Icon(Icons.delete_forever),
                  ),
                )
              ],
            ),
          ),
          appBar: AppBar(),
          persistentFooterButtons: [
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.green)),
              onPressed: playPressed,
              child: Icon(Icons.play_arrow),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.red)),
              onPressed: () {
                ScaffoldMessenger.of(context).clearSnackBars();
                Provider.of<CanvasService>(context, listen: false)
                    .clearCanvas();
              },
              child: Icon(Icons.delete),
            ),
            ElevatedButton(onPressed: savePressed, child: Text('Save')),
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
                      painter: MyPainter(
                          context.watch<CanvasService>().currentCanvas.dots),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
