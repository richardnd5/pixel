import 'package:flutter/material.dart';
import 'package:pixel/services/canvas_service.dart';
import 'package:pixel/views/show_snack_bar.dart';
import 'package:provider/provider.dart';
import 'my_painter.dart';

class PixelPage extends StatefulWidget {
  const PixelPage({Key? key}) : super(key: key);

  @override
  _PixelPageState createState() => _PixelPageState();
}

class _PixelPageState extends State<PixelPage> {
  late CanvasService canvas;

  bool safetyLocked = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      canvas = Provider.of<CanvasService>(context, listen: false);
      canvas.startCanvasService(Size(25, 25), MediaQuery.of(context).size);
    });
  }

  savePressed() {
    ScaffoldMessenger.of(context).clearSnackBars();

    var saved = canvas.saveAndIncrement();
    showSnackBar(context, saved ? 'Canvas Saved' : 'Already Saved');

    if (canvas.showPreviousFrame) {
      canvas.clearCanvas();
      canvas.loadBlankCanvas();
      canvas.drawPreviousCanvas();
    }
  }

  saveOnChangeToggle() {
    Provider.of<CanvasService>(context, listen: false).toggleSaveOnEachChange();
  }

  toggleShowPreviousFrame() {
    canvas.toggleShowPreviousFrame();
  }

  toggleGrid() {
    canvas.toggleGrid();
  }

  playPressed() {
    ScaffoldMessenger.of(context).clearSnackBars();
    canvas.playArrayOfCanvases();
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
              canvas.clearAnimation();
              showSnackBar(context, 'Animation Cleared');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  clearCanvasPressed() {
    setState(() {
      safetyLocked = true;
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    canvas.resetCanvasToScreenDimensions(
        canvas.gridDimensions, canvas.screenSize);
  }

  handleCanvasTap(TapUpDetails details) {
    setState(() {
      safetyLocked = true;
    });
    canvas.checkTapPosition(details.localPosition);
  }

  @override
  Widget build(BuildContext context) {
    var service = context.watch<CanvasService>();
    bool saveOnEachChange = service.saveOnEachChange;
    bool showPreviousFrame = service.showPreviousFrame;
    bool grid = service.grid;

    return Container(
      color: Theme.of(context).backgroundColor,
      child: SafeArea(
        child: Scaffold(
          drawer: _buildDrawer(saveOnEachChange, showPreviousFrame, grid),
          appBar: AppBar(),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(width: 32),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.blue),
                ),
                onPressed: () => canvas.goBackAFrame(),
                child: Icon(Icons.arrow_left_rounded),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.blue),
                ),
                onPressed: () => canvas.goForwardAFrame(),
                child: Icon(Icons.arrow_right_rounded),
              ),
              Spacer(),
              Container(
                width: 100,
                child: ElevatedButton(
                  onPressed: context.watch<CanvasService>().canvasSaved
                      ? null
                      : savePressed,
                  child: Text('Save'),
                ),
              ),
            ],
          ),
          persistentFooterButtons: _buildButtons(grid, context),
          body: InteractiveViewer(
            maxScale: 50,
            child: GestureDetector(
              onTapUp: handleCanvasTap,
              child: CustomPaint(
                size: Size(5000, 5000),
                painter: CanvasPainter(
                  service.currentScreen,
                  gridToggle: grid,
                  gridColor: service.gridLineColor,
                  gridLineWidth: service.gridLineWidth,
                  gridDimensions: service.gridDimensions,
                  cellSize: service.cellSize,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  lockPressed() {
    setState(() {
      safetyLocked = !safetyLocked;
    });
  }

  List<Widget> _buildButtons(bool grid, BuildContext context) {
    return [
      ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) =>
                safetyLocked ? Colors.blueGrey : Colors.transparent)),
        onPressed: lockPressed,
        child: Icon(Icons.lock),
      ),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: !safetyLocked
              ? MaterialStateProperty.resolveWith((states) => Colors.red)
              : null,
        ),
        onPressed: !safetyLocked ? clearCanvasPressed : null,
        child: Icon(Icons.delete),
      ),
      ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith(
                (states) => grid ? Colors.white10 : Colors.lightBlue)),
        onPressed: toggleGrid,
        child: Icon(Icons.grid_4x4),
      ),
      ElevatedButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.resolveWith((states) => Colors.green)),
        onPressed: playPressed,
        child: Icon(Icons.play_arrow),
      ),
    ];
  }

  Drawer _buildDrawer(
    bool saveOnEachChange,
    bool showPreviousFrame,
    bool grid,
  ) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            title: Row(
              children: [
                Switch(
                  value: saveOnEachChange,
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
                  value: showPreviousFrame,
                  onChanged: (_) => toggleShowPreviousFrame(),
                ),
                Text('Show Previous Frame'),
              ],
            ),
          ),
          ListTile(
            title: Row(
              children: [
                Switch(
                  value: grid,
                  onChanged: (_) => toggleGrid(),
                ),
                Text('Toggle Grid'),
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
    );
  }
}
