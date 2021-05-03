import 'dart:ui';

import 'package:flame/gestures.dart';
import 'package:flutter/gestures.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

class SnakeGame extends Game with TapDetector {
  Size screenSize;
  double tileSize;

  SnakeGame() {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
  }

  void render(Canvas canvas) {
  }

  void update(double t) {
  }

  void onTapDown(TapDownDetails d) {
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;
  }
}