import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:pixel/pixel_page.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: PixelPage());
  }
}
