import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LamaTextTheme {
  static TextStyle getStyle(
      {Color color = Colors.white,
      double fontSize = 25,
      FontWeight fontWeight = FontWeight.w500,
      List<Shadow> shadows = const []}) {
    return GoogleFonts.ubuntu(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        shadows: shadows);
  }
}
