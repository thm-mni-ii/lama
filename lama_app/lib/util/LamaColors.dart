import 'package:flutter/material.dart';

///Utility class that contains all colors used in the app.
class LamaColors {
  //Mirroring colors from Colors.class to avoid confusion and mixed usage
  static Color white = Colors.white;
  static Color black = Colors.black;

  //Colors used for math
  static Color bluePrimary = Color.fromARGB(255, 0, 117, 255);
  static Color blueAccent = Color.fromARGB(255, 0, 194, 255);
  //Colors used for german
  static Color redPrimary = Color.fromARGB(255, 211, 21, 67);
  static Color redAccent = Color.fromARGB(255, 233, 30, 98);
  //Colors used for english
  static Color orangePrimary = Color.fromARGB(255, 255, 92, 0);
  static Color orangeAccent = Color.fromARGB(255, 255, 122, 0);
  //Colors used for science
  static Color purplePrimary = Color.fromARGB(255, 102, 62, 194);
  static Color purpleAccent = Color.fromARGB(255, 138, 87, 255);

  static Color greenPrimary = Color.fromARGB(255, 18, 194, 32);
  static Color greenAccent = Color.fromARGB(255, 50, 225, 83);

  static Color profileColor = Color.fromARGB(255, 253, 237, 6);

  static Color shopColor = Color.fromARGB(255, 31, 6, 253);

  static Color mainPink = Color.fromARGB(255, 253, 74, 111);

  static Color errorColor = Color.fromARGB(255, 255, 0, 0);

  /// Determin Color depending on the Subject
  static findSubjectColor(String subject) {
    switch (subject) {
      case "Mathe":
        return blueAccent;
      case "Deutsch":
        return redAccent;
      case "Englisch":
        return orangeAccent;
      case "Sachkunde":
        return purpleAccent;
      case "normal":
        return bluePrimary;
      default:
        return errorColor;
    }
  }
}
