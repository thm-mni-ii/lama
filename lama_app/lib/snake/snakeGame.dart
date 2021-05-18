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
import 'package:lama_app/snake/components/scoreDisplay.dart';

import 'components/apple.dart';
import 'package:lama_app/snake/components/arrowButtons.dart';
import 'package:lama_app/snake/components/pauseButton.dart';

import 'components/snake.dart';

import 'models/position.dart';

import 'package:lama_app/snake/views/view.dart';
import 'package:lama_app/snake/views/homeView.dart';
import 'package:lama_app/snake/views/gameOverView.dart';

class SnakeGame extends Game with TapDetector {
  final bool log = true;

  Background background;
  SnakeComponent snake;

  List<Apple> apples = [];
  Random rnd = Random();
  ScoreDisplay scoreDisplay;
  ArrowButtons arrowButtonDown;
  ArrowButtons arrowButtonUp;
  ArrowButtons arrowButtonLeft;
  ArrowButtons arrowButtonRight;
  PauseButton pauseButton;

  int score = 0;

  Size screenSize;
  double tileSize;

  int maxFieldX = 25;
  int maxFieldY = 25;
  final maxField = true;
  final fieldOffsetY = 0;
  final maxApples = 1;
  final snakeStartVelocity = 2.0;

  bool _finished = false;
  bool _initialized = false;
  bool _running = false;
  double _controlBarRelativeHeight = 0.25;
  double _relativeButtonSize = 0.16;

  View activeView = View.home; // views added
  HomeView homeView;
  GameOverView gameOverView;
  BuildContext _context;

  SnakeGame(this._context) {
    initialize();
  }

  /// This method is vor the initialization process of the game class.
  /// It runs asynchron and it will flag the [_initialized] to true when its finished.
  void initialize() async {
    resize(await Flame.util.initialDimensions());

    background = Background(this, _controlBarRelativeHeight);
    spawnApples();

    homeView = HomeView(this);
    gameOverView = GameOverView(this);

    arrowButtonDown = ArrowButtons(this, _relativeButtonSize, 3, 4, 1.0 - _controlBarRelativeHeight, () => snake.direction = 3);
    arrowButtonUp = ArrowButtons(this, _relativeButtonSize, 1, 3, 1.0 - _controlBarRelativeHeight, () => snake.direction = 1);
    arrowButtonLeft = ArrowButtons(this, _relativeButtonSize, 2, 0, 1.0 - _controlBarRelativeHeight, () => snake.direction = 2);
    arrowButtonRight = ArrowButtons(this, _relativeButtonSize, 4, 1, 1.0 - _controlBarRelativeHeight, () => snake.direction = 4);

    pauseButton = PauseButton(this, _relativeButtonSize, 2, 1.0 - _controlBarRelativeHeight, (tapped) => _running = !tapped);

    // TODO - this has to move to the begin action of the main menu
    spawnSnake();
    scoreDisplay = ScoreDisplay(this);

    Flame.images.loadAll([
      'png/snake.png',
      'png/apple.png',
      'png/snake_body.png',
      'png/snake_body_curve.png',
      'png/snake_head.png',
      'png/snake_tail.png'
    ]);

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
      excludePositions.addAll(snake?.snakeParts?.map((e) => Position(e.fieldX, e.fieldY)) ?? []);
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
      excludePositions.addAll(snake?.snakeParts?.map((e) => Position(e.fieldX, e.fieldY)) ?? []);
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
    snake = SnakeComponent(this, Position(maxFieldX ~/ 2, maxFieldY ~/ 2), snakeStartVelocity);
    // callback when snake bites itself
    snake.callbackBiteItSelf = () => finishGame();
    // callback when the snake hits the border
    snake.callbackCollideWithBorder = () => finishGame();
    // callback when the snake eats an apple
    snake.callbackEatsApple = (apple) {
      score += 1;
      // respawn the eaten apple
      respawnApple(apple);
      snake?.velocity = snakeStartVelocity + (score ~/ 5);
    };

    if (log) {
      developer.log("[SnakeGame][spawnSnake] spawned");
    }
  }

  void render(Canvas canvas) {
    if (_initialized) {
      // draw background
      background.render(canvas);

      // draw home screen
      if (activeView == View.home) {
        homeView.render(canvas);
      } else {
        if (!_finished) {
          snake.render(canvas);
          apples.forEach((element) => element.render(canvas));

          scoreDisplay.render(canvas);
          pauseButton.render(canvas);

          if (_running) {
            arrowButtonDown.render(canvas);
            arrowButtonUp.render(canvas);
            arrowButtonLeft.render(canvas);
            arrowButtonRight.render(canvas);
          }
        } else {
          activeView = View.gameOver;
          gameOverView.render(canvas);
        }
      }
    }
  }

  void update(double t) {
    if (!_finished && _initialized && _running) {
      snake.update(t, apples);
      apples.forEach((element) => element.update(t));
      scoreDisplay.update(t);
     
    }
    if(_finished && _initialized){
      gameOverView.update(t);
    } 
  }

  /// This method finish the actual game
  void finishGame() {
    _finished = true;
    if (log) {
      developer.log("[SnakeGame][finishGame] finished the game");
    }
  }

  /// [dir] 1 = north, 2 = west, 3 = south everything else = east
  void onTapDown(TapDownDetails d) {
    if (!_initialized) {
      return;
    }

    if (activeView != View.home) {
      arrowButtonDown.onTapDown(d);
      arrowButtonUp.onTapDown(d);
      arrowButtonLeft.onTapDown(d);
      arrowButtonRight.onTapDown(d);
      pauseButton.onTapDown(d);
    }

    // start button
    if (homeView.startButton.rect.contains(d.localPosition)) {
      if (activeView == View.home) {
        homeView.startButton.onTapDown();
        _running = true;
      }
    }

    if (activeView == View.gameOver && gameOverView.goBackButton.rect.contains(d.localPosition)){
      gameOverView.goBackButton.onTapDown();

      // close the game widget
      Navigator.pop(_context);
    }
  }

  void resize(Size size) {
    screenSize = size;

    if (maxField && screenSize.width > 0 && screenSize.height > 0) {
      if (screenSize.width < screenSize.height) {
        tileSize = screenSize.width / maxFieldX;
        
        maxFieldY = ((screenSize.height * (1 - _controlBarRelativeHeight) - (tileSize * fieldOffsetY))) ~/ tileSize;
      } else {
        tileSize = screenSize.width / maxFieldX;

        maxFieldX = screenSize.width ~/ tileSize;
      }
    }

    if (log) {
      developer.log("[SnakeGame] screensize = $screenSize");
      developer.log("[SnakeGame] tilesize = $tileSize");
    }
  }
}