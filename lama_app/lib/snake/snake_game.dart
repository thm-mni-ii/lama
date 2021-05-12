import 'dart:ui';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:flame/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/snake/components/background.dart';
import 'package:lama_app/snake/components/score_display.dart';

import 'components/apple.dart';
import 'components/snake.dart';
import 'models/position.dart';

class SnakeGame extends Game with TapDetector {
  final bool log = true;

  Background background;
  SnakeComponent snake;
  List<Apple> apples = [];
  Random rnd = Random();
  ScoreDisplay scoreDisplay;
  int score = 0;

  Size screenSize;
  double tileSize;

  final maxFieldX = 31;
  final maxFieldY = 31;
  final fieldOffsetY = 3;
  final maxApples = 100;

  bool _finished = false;
  bool _initialized = false;

  SnakeGame() {
    initialize();
  }

  /// This method is vor the initialization process of the game class.
  /// It runs asynchron and it will flag the [_initialized] to true when its finished.
  void initialize() async {
    resize(await Flame.util.initialDimensions());

    background = Background(this);
    spawnApples();

    // TODO - this has to move to the begin action of the main menu
    spawnSnake();
    scoreDisplay = ScoreDisplay(this);

    _initialized = true;
  }

  /// This methos respawn the [apple] on a new free field. If there is none the [apple] will despawn.
  void respawnApple(Apple apple) {
    if (apple == null) {
      return;
    }

    // despawn the apple when there is no avaiable space anymore
    if ((maxFieldX * maxFieldY) - snake.snakeParts.length <= apples.length) {
      despawnApple(apple);
    } else {
      if (log) {
        developer.log("[SnakeGame][respawnApple] before [x=${apple.position.x}, y=${apple.position.y}]");
      }

      // get all Positions which are filled with the snake or apples
      var excludePositions = apples.map((e) => e.position).toList();
      excludePositions.addAll(snake?.snakeParts ?? []);
      // set new Position of the eaten apple on a free field
      apple.setRandomPosition(excludePositions);

      if (log) {
        developer.log("[SnakeGame][respawnApple] after  [x=${apple.position.x}, y=${apple.position.y}]");
      }
    }
  }

  /// This method spawns [maxApples] [Apple]s on the game field.
  void spawnApples() {
    while (apples.length < maxApples) {
      var excludePositions = apples.map((e) => e.position).toList();
      excludePositions.addAll(snake?.snakeParts ?? []);
      apples.add(Apple(this, excludePositions));
    }
  }

  /// This method despawns the [apple] from the game.
  void despawnApple(Apple apple) {
    if (apples == null || apples.length == 0) {
      return;
    }

    apples.remove(apple);
  }

  /// This method initialize the snake with its callback
  void spawnSnake() {
    // initialize a new snake
    snake = SnakeComponent(Position(maxFieldX ~/ 2, maxFieldY ~/ 2), this);
    // callback when snake bites itself
    snake.callbackBiteItSelf = () => finishGame();
    // callback when the snake hits the border
    snake.callbackCollideWithBorder = () => finishGame();
    // callback when the snake eats an apple
    snake.callbackEatsApple = (apple) {
      score += 1;
      // respawn the eaten apple
      respawnApple(apple);
    };

    if (log) {
      developer.log("[SnakeGame][spawnSnake] spawned");
    }
  }

  void render(Canvas canvas) {
    if (_initialized) {
      background.render(canvas);
      apples.forEach((element) => element.render(canvas));
      snake.render(canvas);
      scoreDisplay.render(canvas);
    }
  }

  void update(double t) {
    if (!_finished && _initialized) {
      snake.update(t, apples);
      apples.forEach((element) => element.update(t));
      scoreDisplay.update(t);
    }
  }

  /// This method finish the actual game
  void finishGame() {
    _finished = true;
    if (log) {
      developer.log("[SnakeGame][finishGame] finished the game");
    }
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