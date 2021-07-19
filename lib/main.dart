import 'package:flutter/material.dart';
import 'package:pixel/services/canvas_service.dart';
import 'package:pixel/services/sound_service.dart';
import 'package:pixel/views/pixel_page.dart';
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
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SoundService()),
          ChangeNotifierProvider(create: (_) => CanvasService())
        ],
        child: PixelPage(),
      ),
    );
  }
}
