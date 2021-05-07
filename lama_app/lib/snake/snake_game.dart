import 'dart:math';
import 'dart:ui';
import 'dart:developer' as developer;

import 'package:flame/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/snake/components/background.dart';

import 'components/snake.dart';
import 'models/position.dart';

class SnakeGame extends Game with TapDetector {
  Background background;
  SnakeComponent snake;

  Size screenSize;
  double tileSize;

  final maxFieldX = 19;
  final maxFieldY = 19;
  final fieldOffsetY = 3;

  SnakeGame() {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    background = Background(this);
    // snake
    snake = SnakeComponent(Position(1, 1), this);
  }

  void render(Canvas canvas) {
    background.render(canvas);
    snake.render(canvas);
  }

  void update(double t) {
    snake.update(t);
  }

  void onTapDown(TapDownDetails d) {
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / maxFieldX;

    developer.log("The screensize is $screenSize");
    developer.log("The tilesize is $tileSize");

  }
}