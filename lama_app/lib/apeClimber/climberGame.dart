import 'package:flame/components/timer_component.dart';
import 'package:flame/gestures.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/time.dart';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:lama_app/apeClimber/components/MonkeyTimer.dart';
import 'package:lama_app/apeClimber/widgets/monkeyTimerWidget.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/app/model/highscore_model.dart';

class ClimberGame extends BaseGame with TapDetector, HasWidgetsOverlay {
  /// Timer component for display and organize the gametimer.
  MonkeyTimer _timer;
  /// name of the timer widget
  final timerWidgetName = "timer";

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

    _addComponents();
  }

  void _addComponents() {
    components.clear();

    // initialize Timer Component
    _timer = MonkeyTimer(onTimerFinished)
      ..onWidgetUpdated = (widget) {
        removeWidgetOverlay(timerWidgetName);
        addWidgetOverlay(
            timerWidgetName,
            widget);
      };
    add(_timer);
    // start timer
    _timer.timer.start();
  }

  /// This method is the handler when the timer finished.
  void onTimerFinished(MonkeyTimerWidget widget) {
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