import 'dart:math';
import 'dart:ui';
import 'package:flame/components/parallax_component.dart';
import 'package:flame/gestures.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:lama_app/app/model/highscore_model.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/flappyLama/components/flappyGround.dart';
import 'package:lama_app/flappyLama/components/flappyLama.dart';
import 'package:lama_app/flappyLama/components/flappyObstacle.dart';

import 'package:lama_app/flappyLama/components/flappyScoreDisplay.dart';
import 'package:lama_app/flappyLama/widgets/pauseMode.dart';
import 'package:lama_app/flappyLama/widgets/playMode.dart';
import 'package:lama_app/flappyLama/widgets/startScreen.dart';

import 'widgets/gameOverMode.dart';

class FlappyLamaGame extends BaseGame with TapDetector, HasWidgetsOverlay {
  Size screenSize;
  double tileSize;
  int tilesX = 9;
  int tilesY;
  int lifes = 3;

  int score = 0;
  FlappyGround flappyGround;

  BuildContext _context;

  // name of the pauseMode widget
  String _pauseMode = "PauseMode";

  // name of the playMode widget
  String _playMode = "PlayMode";

  String _startScreen = "StartScreen";

  int _gameId = 2;
  bool _started = false;
  //name of the gameOver widget
  String _gameOverMode = "GameOverMode";

  bool _paused = false;
  bool _savedHighscore = false;
  bool _gameover = false;
  int _highScore = 0;
  FlappyLama _lama;
  Random _randomNumber = Random();
  UserRepository _userRepo;

  FlappyLamaGame(this._context, this._userRepo) {
    var back = ParallaxComponent([
      ParallaxImage('png/himmel.png'),
      ParallaxImage('png/clouds_3.png'),
      ParallaxImage('png/clouds_2.png'),
      ParallaxImage('png/clouds.png'),
    ], baseSpeed: Offset(7, 0), layerDelta: Offset(10, 0));

    Flame.images.loadAll([
      'png/kaktus_body.png',
      'png/kaktus_end_bottom.png',
      'png/kaktus_end_top.png',
    ]);

    // add background
    add(back);

    initialize();
  }

  void initialize() async {
    // resize
    resize(await Flame.util.initialDimensions());

    loadStartScreen();
  }

  void saveHighscore() {
    if (!this._savedHighscore) {
      this._savedHighscore = true;
      _userRepo.addHighscore(Highscore(
          gameID: _gameId,
          score: this.score,
          userID: this._userRepo.authenticatedUser.id));
    }
  }

  void resetGame() {
    _gameover = false;
    score = 0;

    // remove gameOver widget
    removeWidgetOverlay(_gameOverMode);

    // removes score
    components.removeWhere((element) => element is FlappyScoreDisplay);

    // removes obstacles
    components.removeWhere((element) => element is FlappyObstacle);

    // removes lama
    components.removeWhere((element) => element is FlappyLama);

    loadStartScreen();
  }

  void loadStartScreen() async {
    // load highscore
    this._highScore = await _userRepo.getMyHighscore(_gameId);

    // add lama
    _lama = FlappyLama(this, 48)
      ..onHitGround = gameOver;
    add(_lama);

    // add start widget
    addWidgetOverlay(
        _startScreen,
        StartScreen(
            highScore: _highScore,
            onStartPressed: startGame
        )
    );
  }

  void resize(Size size) {
    screenSize = Size(
        MediaQuery.of(_context).size.width -
            MediaQuery.of(_context).padding.left -
            MediaQuery.of(_context).padding.right,
        MediaQuery.of(_context).size.height -
            MediaQuery.of(_context).padding.top -
            MediaQuery.of(_context).padding.bottom);
    tileSize = screenSize.width / tilesX;
    tilesY = screenSize.height ~/ tileSize;

    super.resize(size);
  }

  void startGame() {
    resumeEngine();

    // remove start widget
    removeWidgetOverlay(_startScreen);

    // add playmode widget
    addWidgetOverlay(_playMode, PlayMode(onPausePressed: pauseGame));

    _started = true;

    // add obstacles
    add(FlappyObstacle(this, false, 48, () => this.score++));
    add(FlappyObstacle(this, true, 48, () => this.score++));

    // add score
    add(FlappyScoreDisplay(this));
  }

  /// This method pauses the game.
  void pauseGame() {
    pauseEngine();
    _paused = true;

    // removed the playMode widget
    removeWidgetOverlay(_playMode);
    addWidgetOverlay(_pauseMode, PauseMode(onPlayPressed: resumeGame));
  }

  /// This method resumes the game.
  void resumeGame() {
    resumeEngine();
    _paused = false;

    // removed the pauseMode widget
    removeWidgetOverlay(_pauseMode);
    addWidgetOverlay(_playMode, PlayMode(onPausePressed: pauseGame));
  }

  ///This method finishes the game.
  void gameOver() {
    developer.log("Game Over");
    // reduces life
    lifes--;

    pauseEngine();
    _gameover = true;
    _started = false;

    // save highscore
    saveHighscore();

    // add game over widget
    addWidgetOverlay(
        _gameOverMode,
        GameOverMode(
          score: score,
          lifes: lifes,
          onQuitPressed: quit,
          onRetryPressed: resetGame,
        ));
  }

  void quit() {
    removeWidgetOverlay(_gameOverMode);
    _gameover = false;
    Navigator.pop(_context);
  }

  void onTapDown(TapDownDetails d) {
    _lama.onTapDown();
  }

  void update(double t) {
    super.update(t);

    if (_started) {
      // check if the lama hits an obstacle
      components.whereType<FlappyObstacle>().forEach((element) {
        if (element.collides(_lama?.toRect() ?? null) == true) {
          gameOver();
        }
      });
    }
  }
}
