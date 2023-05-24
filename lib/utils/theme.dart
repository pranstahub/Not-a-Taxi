import 'package:flutter/cupertino.dart';

class CustomTheme {
  const CustomTheme();

  static const Color loginGradientStart = Color.fromARGB(255, 220, 241, 228);
  static const Color loginGradientEnd = Color.fromARGB(255, 52, 163, 85);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color.fromARGB(255, 0, 0, 0);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: <Color>[loginGradientStart, loginGradientEnd],
    stops: <double>[0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}