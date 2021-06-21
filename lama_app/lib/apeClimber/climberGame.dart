import 'package:flame/components/timer_component.dart';
import 'package:flame/gestures.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/time.dart';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:lama_app/apeClimber/components/MonkeyTimer.dart';
import 'package:lama_app/apeClimber/widgets/monkeyStartWidget.dart';
import 'package:lama_app/apeClimber/widgets/monkeyTimerWidget.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/app/model/highscore_model.dart';

class ClimberGame extends BaseGame with TapDetector, HasWidgetsOverlay {
  /// Timer component for display and organize the gametimer.
  MonkeyTimer _timer;
  /// name of the timer widget
  final timerWidgetName = "timer";
  /// name of the start screen widget
  final startWidgetName = "start";
  /// a bool flag which indicates if the score of the game has been saved
  bool _savedHighscore = false;
  /// the personal highscore
  int _userHighScore;
  /// the all time highscore in this game
  int _alltimeHighScore;

  Size screenSize;
  double tileSize;
  int tilesX = 9;
  int tilesY;

  int score = 0;

  BuildContext _context;

  int _gameId = 3;

  UserRepository _userRepo;

  ClimberGame(this._context, this._userRepo){
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    // load highscore
    _userHighScore = await _userRepo.getMyHighscore(_gameId);
    // load alltimeHighscore
    _alltimeHighScore = await _userRepo.getHighscore(_gameId);

    addWidgetOverlay(
        startWidgetName,
        MonkeyStartWidget(
            userHighScore: _userHighScore,
            alltimeHighScore: _alltimeHighScore,
            onStartPressed: _startGame)
    );
  }

  void _startGame() {
    _addComponents();
    removeWidgetOverlay(startWidgetName);
  }

  void _addComponents() {
    components.clear();

    // initialize Timer Component
    _timer = MonkeyTimer(_onTimerFinished)
      ..onWidgetUpdated = _onTimerWidgetUpdated;
    add(_timer);

    // start timer
    _timer.start();
  }

  /// This method saves the actual Score to the database for the user which is logged in.
  ///
  /// sideffects:
  ///   [_savedHighscore] = true
  void _saveHighscore() {
    if (!_savedHighscore) {
      _savedHighscore = true;
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
    tilesY = screenSize.height ~/ tileSize;

    super.resize(size);
  }

   void onTapDown(TapDownDetails d) {
  }
}