import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:pixel/pixel_page.dart';
import 'package:pixel/services/canvas_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (_) => CanvasService(),
        child: PixelPage(),
      ),
    );
  }
}
