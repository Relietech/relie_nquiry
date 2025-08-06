import 'package:flutter/material.dart';

class AppColors {
  static const Color appColor = Colors.blue;

  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color black45 = Colors.black45;
  static const Color red = Colors.red;

  /// New Colors
  static const Color themeRed = Color(0xffff595e);
  static const Color themeBlue = Colors.blue;
  static const Color themeYellow = Color(0xffffca3a);
  static const Color themeGreen = Color(0xff23a63e);
  static const Color themeViolet = Color(0xffc982ff);
  static const Color darkBlue = Color(0xff4683aa);
  static const Color darkYellow = Color(0xffffa347);
  static const Color darkRed = Color(0xfff64c4f);


  static const Gradient themGradient = LinearGradient(
    colors: [
      Color(0xFF229CB8),
      Color(0xFF2098B3),
      Color(0xFF13859f),
      Color(0xFF066a81),
      Color(0xFF066a81),
    ],
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
  );
}
