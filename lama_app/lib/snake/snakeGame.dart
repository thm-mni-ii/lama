import 'dart:ui';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/app/model/highscore_model.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/snake/components/background.dart';
import 'package:lama_app/snake/components/scoreDisplay.dart';

import 'components/apple.dart';
import 'package:lama_app/snake/components/arrowButton.dart';
import 'package:lama_app/snake/components/pauseButton.dart';

import 'components/snake.dart';

import 'models/position.dart';

import 'package:lama_app/snake/views/view.dart';
import 'package:lama_app/snake/views/homeView.dart';
import 'package:lama_app/snake/views/gameOverView.dart';

/// This class represents the Snake game and its components.
class SnakeGame extends Game with TapDetector {
  final bool log = true;
  Background background;
  SnakeComponent snake;

  /// id of the game
  final gameId = 1;

  /// a bool flag which indicates if the score of the game has been saved
  bool _savedHighScore = false;

  /// the personal highScore
  int userHighScore;

  /// the all time highScore in this game
  int allTimeHighScore;

  /// all apples on the game field
  List<Apple> apples = [];
  Random rnd = Random();
  ScoreDisplay scoreDisplay;
  ArrowButton arrowButtonDown;
  ArrowButton arrowButtonUp;
  ArrowButton arrowButtonLeft;
  ArrowButton arrowButtonRight;
  PauseButton pauseButton;

  int score = 0;

  Size screenSize;
  double tileSize;

  /// max fields on the x axis
  int maxFieldX = 25;

  /// max fields on the y axis
  int maxFieldY = 25;

  /// flag to maximise the game field
  final maxField = true;

  /// game field offset to the left and right
  final fieldOffsetY = 0;

  /// apples to spawn
  final maxApples = 20;

  /// start velocity of the snake
  final snakeStartVelocity = 2.0;

  /// flag to indicate if the game has finished
  bool _finished = false;

  /// flag to indicate if the game is initializes
  bool _initialized = false;

  /// flag to indicate if the game runs
  bool _running = false;

  /// height of the controlbar relative to the screen height
  double _controlBarRelativeHeight = 0.25;

  /// height of the buttons relative to the screen height
  double _relativeButtonSize = 0.16;

  /// audioplayer
  AudioCache _bitePlayer;

  /// active view for displaying different states
  View activeView = View.home; // views added
  HomeView homeView;
  GameOverView gameOverView;

  /// context of the game to allow access to the navigator
  BuildContext context;

  /// repository to access the database with the logged in user
  UserRepository userRepo;

  /// flag to indicate if the highscore already saved
  bool _saved = false;

  SnakeGame(this.context, this.userRepo) {
    initialize();
    developer.log("${MediaQuery.of(context).size.width}");
    developer.log("${MediaQuery.of(context).size.height}");
    developer.log("${MediaQuery.of(context).padding}");
  }

  /// This method is vor the initialization process of the game class.
  /// It runs asynchron and it will flag the [_initialized] to true when its finished.
  void initialize() async {
    resize(await Flame.util.initialDimensions());
    // load _serHighScore
    userHighScore = await userRepo.getMyHighscore(gameId);
    // load allTimeHighScore
    allTimeHighScore = await userRepo.getHighscore(gameId);

    background = Background(this, _controlBarRelativeHeight);
    spawnApples();

    _bitePlayer =
        AudioCache(prefix: 'assets/sounds/', fixedPlayer: AudioPlayer());

    homeView = HomeView(this);
    gameOverView = GameOverView(this);

    arrowButtonDown = ArrowButton(
        this,
        _relativeButtonSize,
        3,
        1,
        1.0 - _controlBarRelativeHeight,
        () => snake.direction = SnakeDirection.South);
    arrowButtonUp = ArrowButton(
        this,
        _relativeButtonSize,
        1,
        3,
        1.0 - _controlBarRelativeHeight,
        () => snake.direction = SnakeDirection.North);
    arrowButtonLeft = ArrowButton(
        this,
        _relativeButtonSize,
        2,
        0,
        1.0 - _controlBarRelativeHeight,
        () => snake.direction = SnakeDirection.West);
    arrowButtonRight = ArrowButton(
        this,
        _relativeButtonSize,
        4,
        4,
        1.0 - _controlBarRelativeHeight,
        () => snake.direction = SnakeDirection.East);

    pauseButton = PauseButton(this, _relativeButtonSize, 2,
        1.0 - _controlBarRelativeHeight, (tapped) => _running = !tapped);

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

  /// This method will resize all components of this class.
  void resizeComponents() {
    background?.resize();
    homeView?.resize();
    gameOverView?.resize();
    arrowButtonDown?.resize();
    arrowButtonUp?.resize();
    arrowButtonLeft?.resize();
    arrowButtonRight?.resize();
    pauseButton?.resize();
    scoreDisplay?.resize();
  }

  /// This method saves the actual Score to the database for the user which is logged in.
  ///
  /// sideffects:
  ///   [_savedHighScore] = true
  void _saveHighScore() {
    if (!_savedHighScore) {
      _savedHighScore = true;
      userRepo.addHighscore(Highscore(
          gameID: gameId, score: score, userID: userRepo.authenticatedUser.id));
    }
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
        developer.log(
            "[SnakeGame][respawnApple] before [x=${apple.position.x}, y=${apple.position.y}]");
      }

      // get all Positions which are filled with the snake or apples
      var excludePositions = apples.map((e) => e.position).toList();
      excludePositions.addAll(
          snake?.snakeParts?.map((e) => Position(e.fieldX, e.fieldY)) ?? []);
      // set new Position of the eaten apple on a free field
      apple.setRandomPosition(excludePositions);

      if (log) {
        developer.log(
            "[SnakeGame][respawnApple] after  [x=${apple.position.x}, y=${apple.position.y}]");
      }
    }
  }

  /// This method spawns [maxApples] [Apple]s on the game field.
  void spawnApples() {
    while (apples.length < maxApples) {
      var excludePositions = apples.map((e) => e.position).toList();
      excludePositions.addAll(
          snake?.snakeParts?.map((e) => Position(e.fieldX, e.fieldY)) ?? []);
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
    snake = SnakeComponent(
        this, Position(maxFieldX ~/ 2, maxFieldY ~/ 2), snakeStartVelocity);
    // callback when snake bites itself
    snake.callbackBiteItSelf = () => finishGame();
    // callback when the snake hits the border
    snake.callbackCollideWithBorder = () => finishGame();
    // callback when the snake eats an apple
    snake.callbackEatsApple = (apple) {
      playAppleBiteSound();
      score += 1;
      // respawn the eaten apple
      respawnApple(apple);
      snake?.velocity = snakeStartVelocity + (score ~/ 5);
    };

    if (log) {
      developer.log("[SnakeGame][spawnSnake] spawned");
    }
  }

  Future<void> playAppleBiteSound() async {
    await _bitePlayer.play('apple_bite.mp3');
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
    if (_finished && _initialized) {
      gameOverView.update(t);

      if (!this._saved) {
        this._saved = true;
        userRepo.addHighscore(Highscore(
            gameID: 1,
            score: this.score,
            userID: this.userRepo.authenticatedUser.id));
      }
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

    if (activeView == View.gameOver &&
        gameOverView.goBackButton.rect.contains(d.localPosition)) {
      gameOverView.goBackButton.onTapDown();

      // close the game widget
      Navigator.pop(context);
    }
  }

  void resize(Size size) {
    screenSize = Size(
        MediaQuery.of(context).size.width -
            MediaQuery.of(context).padding.left -
            MediaQuery.of(context).padding.right,
        MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top -
            MediaQuery.of(context).padding.bottom);

    if (maxField && screenSize.width > 0 && screenSize.height > 0) {
      if (screenSize.width < screenSize.height) {
        tileSize = screenSize.width / maxFieldX;

        maxFieldY = ((screenSize.height * (1 - _controlBarRelativeHeight) -
                (tileSize * fieldOffsetY))) ~/
            tileSize;
      } else {
        tileSize = screenSize.width / maxFieldX;

        maxFieldX = screenSize.width ~/ tileSize;
      }

      resizeComponents();
    }

    if (log) {
      developer.log("[SnakeGame] screensize = $screenSize");
      developer.log("[SnakeGame] tilesize = $tileSize");
    }
  }
}
