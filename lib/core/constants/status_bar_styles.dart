import 'package:flutter/services.dart';

const SystemUiOverlayStyle darkAppBarSystemOverlayStyle = SystemUiOverlayStyle(
  statusBarIconBrightness:
      Brightness.light, // White icons/text for dark background
  statusBarBrightness:
      Brightness.dark, // For iOS: dark status bar content (white text)
);

// Style for a light AppBar (e.g., white) - makes status bar icons black
const SystemUiOverlayStyle lightAppBarSystemOverlayStyle = SystemUiOverlayStyle(
  //statusBarColor: Colors.transparent, // Make status bar transparent to show AppBar color
  statusBarIconBrightness:
      Brightness.dark, // Black icons/text for light background
  statusBarBrightness:
      Brightness.light, // For iOS: light status bar content (black text)
);
