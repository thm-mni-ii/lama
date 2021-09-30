import 'dart:ui';
import 'dart:developer' as developer;

import 'package:flame/components/parallax_component.dart';
import 'package:flame/gestures.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/app/model/highscore_model.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/flappyLama/components/flappyLama.dart';
import 'package:lama_app/flappyLama/components/flappyObstacle.dart';
import 'package:lama_app/flappyLama/components/flappyScoreDisplay.dart';
import 'package:lama_app/flappyLama/widgets/playModeWidget.dart';
import 'package:lama_app/flappyLama/widgets/startScreen.dart';

import '../app/screens/game_list_screen.dart';
import 'widgets/gameOverMode.dart';

/// This class represents the Flappy Lama game and its components.
class FlappyLamaGame extends BaseGame with TapDetector, HasWidgetsOverlay {
  // SETTINGS
  // --------
  /// the id of flappyLama game which is used in the database
  final int _gameId = 2;

  /// amount of tiles on the x coordinate
  final int tilesX = 9;

  /// size of the lama
  final double _lamaSize = 48;
  // name of the pauseMode widget
  final String _pauseMode = "PauseMode";
  // name of the playMode widget
  final String _playMode = "PlayMode";
  // name of the startScreen widget
  final String _startScreen = "StartScreen";
  // name of the gameOver widget
  final String _gameOverMode = "GameOverMode";

  /// score where the difficulty will increase
  final int _difficultyScore = 5;

  /// how many times the user can play this game
  int _lifes = 3;
  // --------
  // SETTINGS

  /// obstacle list
  List<FlappyObstacle> obstacles = [];

  /// screensize of the game
  Size _screenSize;

  /// pixel of the quadratic tiles
  double _tileSize;

  /// amount of tiles on the y coordinate
  int _tilesY;

  /// the achieved score in this round
  int score = 0;

  /// necessary context for determine the actual screensize
  BuildContext _context;

  /// a bool flag which indicates if the game has started
  bool _started = false;

  /// a bool flag which indicates if the score of the game has been saved
  bool _savedHighscore = false;

  /// the personal highscore
  int _userHighScore = 0;

  /// the all time highscore in this game
  int _alltimeHighScore = 0;

  /// the lama [AnimationComponent]
  FlappyLama _lama;

  /// the [UserRepository] to interact with the database and get the user infos
  UserRepository _userRepo;

  /// Getter of [_started]
  bool get started {
    return _started;
  }

  /// Getter of [_screenSize]
  Size get screenSize {
    return _screenSize;
  }

  /// Getter of [_tilesY]
  int get tilesY {
    return _tilesY;
  }

  /// Getter of [_tileSize]
  double get tileSize {
    return _tileSize;
  }

  FlappyLamaGame(this._context, this._userRepo) {
    // background with moving clouds
    var back = ParallaxComponent([
      ParallaxImage('png/himmel.png'),
      ParallaxImage('png/clouds_3.png'),
      ParallaxImage('png/clouds_2.png'),
      ParallaxImage('png/clouds.png'),
    ], baseSpeed: Offset(7, 0), layerDelta: Offset(10, 0));

    // load all obstacle pngs
    Flame.images.loadAll([
      'png/kaktus_body.png',
      'png/kaktus_end_bottom.png',
      'png/kaktus_end_top.png',
    ]);

    // add background
    add(back);

    initializeAsync();
  }

  /// This method load the [Size] of the screen and loads the StartScreen
  void initializeAsync() async {
    // resize
    resize(await Flame.util.initialDimensions());

    loadStartScreenAsync();
  }

  /// This method saves the actual Score to the database for the user which is logged in.
  ///
  /// sideffects:
  ///   [_savedHighscore] = true
  void saveHighscore() {
    if (!_savedHighscore) {
      _savedHighscore = true;
      _userRepo.addHighscore(Highscore(
          gameID: _gameId,
          score: score,
          userID: _userRepo.authenticatedUser.id));
    }
  }

  /// This method resets the game so another round can start.
  ///
  /// sideeffects:
  ///   [score] = 0
  ///   [_savedHighscore] = false
  ///   [components]
  ///   displayed widget
  void resetGame() {
    _savedHighscore = false;
    score = 0;

    // remove gameOver widget
    removeWidgetOverlay(_gameOverMode);

    // removes score
    components.removeWhere((element) => element is FlappyScoreDisplay);

    // removes obstacles
    components.removeWhere((element) => element is FlappyObstacle);

    // removes lama
    components.removeWhere((element) => element is FlappyLama);

    loadStartScreenAsync();
  }

  /// This method load the necessary components to start begin a new game.
  ///
  /// It loads/adds...
  ///   ... the [_userHighscore]
  ///   ... the [_alltimeHighscore]
  ///   ... the [_lama]
  ///   ... the start Screen widget
  void loadStartScreenAsync() async {
    // load highscore
    this._userHighScore = await _userRepo.getMyHighscore(_gameId);
    // load alltimeHighscore
    this._alltimeHighScore = await _userRepo.getHighscore(_gameId);

    // add lama
    _lama = FlappyLama(this, _lamaSize)..onHitGround = gameOver;
    add(_lama);

    // add start widget
    addWidgetOverlay(
        _startScreen,
        StartScreen(
            userHighScore: _userHighScore,
            alltimeHighScore: _alltimeHighScore,
            onStartPressed: startGame));
  }

  void resize(Size size) {
    // get the screensize fom [MediaQuery] because [size] is incorrect on some devices
    _screenSize = Size(
        MediaQuery.of(_context).size.width -
            MediaQuery.of(_context).padding.left -
            MediaQuery.of(_context).padding.right,
        MediaQuery.of(_context).size.height -
            MediaQuery.of(_context).padding.top -
            MediaQuery.of(_context).padding.bottom);
    // calculates by the width of the screen
    _tileSize = screenSize.width / tilesX;
    _tilesY = screenSize.height ~/ tileSize;

    super.resize(size);
  }

  void startGame() {
    if (_userRepo.getLamaCoins() < GameListScreen.games[_gameId - 1].cost) {
      Navigator.pop(_context, "NotEnoughCoins");
      return;
    }
    _userRepo.removeLamaCoins(GameListScreen.games[_gameId - 1].cost);
    // resum game
    resumeEngine();

    // remove start widget
    removeWidgetOverlay(_startScreen);

    // add playmodebutton widget
    addWidgetOverlay(
        _playMode, PlayModeButton(playMode: true, onButtonPressed: pauseGame));

    _started = true;

    // add obstacles
    obstacles.clear();
    obstacles.add(FlappyObstacle(this, false, _lamaSize, addScore, null, 7, 8));
    obstacles.add(FlappyObstacle(this, true, _lamaSize, addScore, null, 7, 8));

    add(obstacles[0]);
    add(obstacles[1]);

    // add reset function = set the ref hole to constraint the hole size and position
    obstacles[0].onResetting = obstacles[1].setConstraints;
    obstacles[1].onResetting = obstacles[0].setConstraints;

    // initial change the second obstacle to avoid a to large gap
    obstacles[1].setConstraints(obstacles[0].holeIndex, obstacles[0].holeSize);
    obstacles[1].resetObstacle();
    obstacles[0].resetObstacle();

    // add score
    add(FlappyScoreDisplay(this));
  }

  /// This methods adds up the score and changes the holesize depending on the score
  void addScore(FlappyObstacle obstacle) {
    score++;

    if (score > _difficultyScore) {
      obstacle.maxHoleSize = 3;
      obstacle.minHoleSize = 2;
    }
  }

  /// This method pauses the game.
  void pauseGame() {
    pauseEngine();

    // removed the playMode widget
    removeWidgetOverlay(_playMode);
    addWidgetOverlay(_pauseMode,
        PlayModeButton(playMode: false, onButtonPressed: resumeGame));
  }

  /// This method resumes the game.
  void resumeGame() {
    resumeEngine();

    // remove the pauseMode widget
    removeWidgetOverlay(_pauseMode);

    // add the playMode widget
    addWidgetOverlay(
        _playMode, PlayModeButton(playMode: true, onButtonPressed: pauseGame));
  }

  /// This method finishes the game.
  ///
  /// sideeffects:
  ///   [_lifes] -= 1
  ///   [_started] = false
  ///   removes the play/pause widget
  ///   adds [GameOverMode] widget
  void gameOver() {
    developer.log("Game Over");

    // removes playMode and pausemode widget
    removeWidgetOverlay(_playMode);
    removeWidgetOverlay(_pauseMode);
    components.removeWhere((element) => element is FlappyScoreDisplay);

    // reduces life
    _lifes--;

    pauseEngine();
    _started = false;

    // save highscore
    saveHighscore();

    // add game over widget
    addWidgetOverlay(
        _gameOverMode,
        GameOverMode(
          score: score,
          lifes: _lifes,
          onQuitPressed: quit,
          onRetryPressed: resetGame,
        ));
  }

  /// This method closes the game widget.
  void quit() {
    removeWidgetOverlay(_gameOverMode);
    Navigator.pop(_context);
  }

  void onTapDown(TapDownDetails d) {
    if (_started) {
      _lama.onTapDown();
    }
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
