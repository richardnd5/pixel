import 'package:flutter/material.dart';
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
      theme: ThemeData(),
      home: ChangeNotifierProvider(
        create: (_) => CanvasService(),
        child: PixelPage(),
      ),
    );
  }
}
