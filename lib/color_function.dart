// // void setImageBytes(imageBytes) {
// //   print("setImageBytes");
// //   List<int> values = imageBytes.buffer.asUint8List();
// //   photo = null;
// //   photo = img.decodeImage(values);
// // }

// // image lib uses uses KML color format, convert #AABBGGRR to regular #AARRGGBB
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// int abgrToArgb(int argbColor) {
//   print("abgrToArgb");
//   int r = (argbColor >> 16) & 0xFF;
//   int b = argbColor & 0xFF;
//   return (argbColor & 0xFF00FF00) | (b << 16) | r;
// }

// // FUNCTION

// Future<Color> _getColor() async {
//   print("_getColor");
//   Uint8List data;

//   try {
//     // get image byte list.
//     // data = (await NetworkAssetBundle(Uri.parse(coverData)).load(coverData))
//     //     .buffer
//     //     .asUint8List();
//   } catch (ex) {
//     print(ex.toString());
//   }

//   print("setImageBytes....");
//   setImageBytes(data);

// //FractionalOffset(1.0, 0.0); //represents the top right of the [Size].
//   double px = 1.0;
//   double py = 0.0;

//   int pixel32 = photo.getPixelSafe(px.toInt(), py.toInt());
//   int hex = abgrToArgb(pixel32);
//   print("Value of int: $hex ");

//   return Color(hex);
// }
