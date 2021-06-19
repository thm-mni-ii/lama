import 'package:flame/components/component.dart';
import 'package:flame/gestures.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/components/parallax_component.dart';

import 'package:lama_app/apeClimber/components/climberTree.dart';
import 'package:lama_app/apeClimber/components/climberTree2.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/apeClimber/components/MonkeyTimer.dart';
import 'package:lama_app/apeClimber/components/monkey.dart';
import 'package:lama_app/apeClimber/widgets/monkeyStartWidget.dart';
import 'package:lama_app/apeClimber/widgets/monkeyTimerWidget.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/app/model/highscore_model.dart';

class ClimberGame extends BaseGame with TapDetector, HasWidgetsOverlay {
  /// amount of tiles on the x coordinate
  final int tilesX = 9;
  /// Timer component for display and organize the gametimer.
  MonkeyTimer _timer;
  /// name of the timer widget
  final timerWidgetName = "timer";
  /// name of the start screen widget
  final startWidgetName = "start";
  /// a bool flag which indicates if the score of the game has been saved
  bool _savedHighScore = false;
  /// the personal highScore
  int _userHighScore;
  /// the all time highScore in this game
  int _allTimeHighScore;
  /// the achieved score in this round
  int score = 0;
  /// necessary context for determine the actual screenSize
  BuildContext _context;

  Size screenSize;
  double tileSize;
  /// amount of tiles on the y coordinate
  int _tilesY;
  SpriteComponent tree1;
  SpriteComponent tree2;
  SpriteComponent tree3;

  int _gameId = 3;
  /// the [UserRepository] to interact with the database and get the user infos
  UserRepository _userRepo;

  ClimberGame(this._context, this._userRepo) {
    var back = ParallaxComponent([
      ParallaxImage('png/himmel.png'),
      ParallaxImage('png/clouds_3.png'),
      ParallaxImage('png/clouds_2.png'),
      ParallaxImage('png/clouds.png'),
    ], baseSpeed: Offset(7, 0), layerDelta: Offset(10, 0));
    Flame.images.loadAll([
      'png/tree6th2.png',
      'png/tree6th2top.png',
    ]);
    
    add(back);

    initialize();
  }
   

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    // load _serHighScore
    _userHighScore = await _userRepo.getMyHighscore(_gameId);
    // load allTimeHighScore
    _allTimeHighScore = await _userRepo.getHighscore(_gameId);

    addWidgetOverlay(
        startWidgetName,
        MonkeyStartWidget(
            userHighScore: _userHighScore,
            alltimeHighScore: _allTimeHighScore,
            onStartPressed: _startGame)
    );
  }
  void _startGame() {
    _addComponents();
    removeWidgetOverlay(startWidgetName);
  }

  void _addComponents() {
    components.clear();
    tree1 = ClimberTree(this, 0);
    tree2 = ClimberTree2(this, 1);
    tree3 = ClimberTree(this, 2);
    add(tree1);
    add(tree2);
    add(tree3);

    // initialize Timer Component
    _timer = MonkeyTimer(_onTimerFinished)
      ..onWidgetUpdated = _onTimerWidgetUpdated;
    add(_timer);
    add(Monkey(144));

    // start timer
    _timer.start();
  }

  /// This method saves the actual Score to the database for the user which is logged in.
  ///
  /// sideffects:
  ///   [_savedHighScore] = true
  void _saveHighScore() {
    if (!_savedHighScore) {
      _savedHighScore = true;
      _userRepo.addHighscore(Highscore(
          gameID: _gameId,
          score: score,
          userID: _userRepo.authenticatedUser.id));
    }
  }

  /// This method is the handler when the timer finished.
  void _onTimerFinished(MonkeyTimerWidget widget) {
    removeWidgetOverlay(timerWidgetName);
    addWidgetOverlay(
        timerWidgetName,
        widget);
  }

  /// This method is the handler when the timer finished.
  void _onTimerWidgetUpdated(MonkeyTimerWidget widget) {
    removeWidgetOverlay(timerWidgetName);
    addWidgetOverlay(
        timerWidgetName,
        widget);
  }

  void resize(Size size) {
    screenSize = Size(
        MediaQuery.of(_context).size.width - MediaQuery.of(_context).padding.left - MediaQuery.of(_context).padding.right,
        MediaQuery.of(_context).size.height - MediaQuery.of(_context).padding.top - MediaQuery.of(_context).padding.bottom);

    tileSize = screenSize.width / tilesX;
    _tilesY = screenSize.height ~/ tileSize;

    super.resize(size);
  }

  void onTapDown(TapDownDetails d) {
    components.whereType<Monkey>().forEach((element) {
      if (d.localPosition.dx < screenSize.width / 2) {
        element.move(ClimbSide.Left);
      } else {
        element.move(ClimbSide.Right);
      }
    });
  }
}