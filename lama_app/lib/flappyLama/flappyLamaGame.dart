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
import 'package:lama_app/flappyLama/views/gameOverView.dart';
import 'package:lama_app/flappyLama/views/view.dart';
import 'package:lama_app/flappyLama/widgets/pauseMode.dart';
import 'package:lama_app/flappyLama/widgets/playMode.dart';
import 'package:lama_app/flappyLama/widgets/startScreen.dart';

class FlappyLamaGame extends BaseGame with TapDetector, HasWidgetsOverlay {
  Size screenSize;
  double tileSize;
  int tilesX = 9;
  int tilesY;

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
  bool _paused = false;
  bool _savedHighscore = false;
  int _highScore = 0;
  FlappyLama _lama;
  Random _randomNumber = Random();
  UserRepository _userRepo;
  GameOverView gameOverView;

  FlappyLamaGame(this._context, this._userRepo) {
    var back = ParallaxComponent([
      ParallaxImage('png/himmel.png'),
      ParallaxImage('png/clouds_3.png'),
      ParallaxImage('png/clouds_2.png'),
      ParallaxImage('png/clouds.png'),
    ], baseSpeed: Offset(7, 0), layerDelta: Offset(10, 0));
   
    // add background
    add(back); 
    // add lama
    _lama = FlappyLama(this, 48)
      ..onHitGround = () => developer.log("GROUND");
    add(_lama);
    loadPersonalHighscoreAsync();
    addWidgetOverlay(_playMode, PlayMode(onPausePressed: pauseGame));
      _startScreen,
      StartScreen(highScore: _highScore,
        onStartPressed: startGame
      )
   
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());

    Flame.images.loadAll([
      'png/kaktus_body.png',
      'png/kaktus_end_bottom.png',
      'png/kaktus_end_top.png',
    ]);

    // add ground
    //add(FlappyGround(this));
    // TODO: move to where the game will start (tap the first time)
    // add obstacles
    add(FlappyObstacle(
      this,
      false,
            48,
      () => this.score++,
      () => developer.log("HIT"),
    ));
    add(FlappyObstacle(this, true, 48, () => this.score++));
    // add score
    add(FlappyScoreDisplay(this));
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

  void loadPersonalHighscoreAsync() async {
    this._highScore = await _userRepo.getMyHighscore(_gameId);
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

  void startGame(){
    removeWidgetOverlay(_startScreen);
    addWidgetOverlay(
        _playMode,
        PlayMode(
            onPausePressed: pauseGame)
    );
    initialize();
    _started = true;
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

  void onTapDown(TapDownDetails d) {
    activeView = View.playing;
    _lama.onTapDown();
  }

  void update(double t) {
    // check if the lama hits an obstacle
    components.whereType<FlappyObstacle>().forEach((element) {
      if (element.collides(_lama?.toRect() ?? null) == true) {
        activeView = View.gameOver;
      }
    });
    if (activeView == View.gameOver) {
      gameOver();
    }

    super.update(t);
  }

  void gameOver() {
    add(gameOverView);
    pauseGame();
  }
}
