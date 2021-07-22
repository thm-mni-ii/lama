import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

///Utility class that provides a unified text theme.
class LamaTextTheme {
  ///Returns a TextStyle with configurable [color], [fontSize], [fontWeight], [shadows] and if its [monospace].
  static TextStyle getStyle(
      {Color color = Colors.white,
      double fontSize = 25,
      FontWeight fontWeight = FontWeight.w700,
      List<Shadow> shadows = const [],
      bool monospace = false}) {
    if (monospace)
      return GoogleFonts.ubuntuMono(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          shadows: shadows);
    return GoogleFonts.ubuntu(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        shadows: shadows);
  }
}
