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

import 'components/snake_component.dart';
import 'models/position.dart';

class SnakeGame extends Game with TapDetector {
  final bool debugMovement = true;

  Background background;
  SnakeComponent snake;
  double snakeVelocity = 5;
  int snakeDirection = 1;

  double deltaCounter = 0;
  Random rnd = Random();

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
    snake = SnakeComponent(Position(1, 1), tileSize, 20, 20, fieldOffsetY);
  }

  void render(Canvas canvas) {
    background.render(canvas);
    snake.render(canvas);
  }

  void update(double t) {
    deltaCounter += t;
    // moves the snake depending on its velocity
    if (deltaCounter / (1 / snakeVelocity) > 1.0) {
      // when debug_movement is active the snake moves towards an random direction
      snake.moveSnake(debugMovement ? rnd.nextInt(3) : snakeDirection, rnd.nextInt(100) > 90);
      // resets the deltaCounter
      deltaCounter = 0;
    }
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