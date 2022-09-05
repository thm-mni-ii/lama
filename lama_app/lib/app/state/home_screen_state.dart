import 'package:flutter_tts/flutter_tts.dart';

/// Authors: J.Wißbach and A.Grishin

/*
In dieser Klasse wird gespeichert, ob TTS angeschaltet ist oder nicht.
Der bool "isTTSTurnedOn" entspricht der Einstellung von TTS'.
Ist der bool true ist TTS angeschaltet, bei false ausgeschaltet.
Mit der toggle Methode kann man den Zustand auf den jeweils anderen ändern.
Mit "isTTS" kann man den Wert von "isTTSTurnedOn" abfragen.

*/

class home_screen_state {
  static bool isTTSTurnedOn = true;
  static FlutterTts flutterTts = FlutterTts();

  static toggle() async {
    if(isTTSTurnedOn) {
      isTTSTurnedOn = false;
      await flutterTts.stop();
    } else {
      isTTSTurnedOn = true;
    }
  }
  static isTTs() {
    return isTTSTurnedOn;
  }
}