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
  final bool log = true;

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
    // snake with starting location
    spawnSnake();
  }

  /// This method initialize the snake with its callback
  void spawnSnake() {
    // initialize a new snake
    snake = SnakeComponent(Position(maxFieldX ~/ 2, maxFieldY ~/ 2), this);
    // TODO: callback when the snake bites itself
    snake.callbackBiteItSelf = () => spawnSnake();

    if (log) {
      developer.log("[SnakeGame][spawnSnake]");
    }
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

    if (log) {
      developer.log("[SnakeGame] screensize = $screenSize");
      developer.log("[SnakeGame] tilesize = $tileSize");
    }
  }
}