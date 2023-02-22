import 'dart:collection';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/apeClimber/components/treeSprite.dart';

import '../apeClimber/components/climberBranches.dart';
import '../apeClimber/components/monkeyTimer.dart';
import '../apeClimber/components/tree.dart';
import '../apeClimber/widgets/monkeyScoreWidget.dart';
import '../apeClimber/widgets/monkeyTimerWidget.dart';
import '../app/repository/user_repository.dart';
import '../util/LamaColors.dart';
import 'backgroundApeClimber.dart';
import 'monkeyComponent.dart';

class ApeClimberGame extends FlameGame with TapDetector, HasCollisionDetection {
  int time = 120;
  late TextPaint pointsText;
  late TextPaint timeText;
  // SETTINGS
  // --------
  /// amount of tiles on the x coordinate
  final int tilesX = 9;

  /// size of the monkey
  final double _monkeySize = 96;

  /// name of the timer widget
  final timerWidgetName = "timer";

  /// name of the start screen widget
  final startWidgetName = "start";

  /// name of the end screen widget
  final endScreenWidgetName = "gameOver";

  /// name of the end screen widget
  final scoreWidgetName = "score";

  /// name of the end screen widget
  final playPauseWidgetName = "playmode";

  /// id of the game
  final _gameId = 3;

  /// Time for each click animation
  final _animationTime = 0.125;

  /// Amount of Components the Tree consists of
  final _treeComponentAmount = 5;
  // --------
  // SETTINGS
  /// flag which indicates if the game is running
  bool _running = true;

  /// a bool flag which indicates if the score of the game has been saved
  bool _savedHighScore = false;

  /// flag if the background is moving
  bool _backMoving = false;

  /// time left for the animation of the background
  double _backgroundMoveTimeLeft = 0;

  /// the personal highScore
  int userHighScore = 0;

  /// the all time highScore in this game
  late int _allTimeHighScore;

  /// the achieved score in this round
  int score = 0;

  late Monkey _monkey;

  Queue<ClimbSide> _inputQueue = Queue();

  /// Tree component
  late Tree _tree;

  late TreeSprite _treeSprite;

  /// Timer component for display and organize the gametimer.
  late MonkeyTimer _timer;

/*
    /// Background component
  ParallaxComponent _back;
  */

  /// pixel left which the background has to move
  late ClimberBranches _climberBranches;
  late double branchSize;

  /// the [UserRepository] to interact with the database and get the user infos
  late UserRepository _userRepo;

  /// necessary context for determine the actual screenSize
  BuildContext _context;

  late Size screenSize;

  ApeClimberGame(this._context, this._userRepo) {
    Flame.images.loadAll([
      'png/tree7th.png',
      'png/tree7th2.png',
      'png/stick_3.png',
    ]);

    // initialize();
  }

  @override
  Future<void> onLoad() async {
    //   resize(await Flame.util.initialDimensions()); --wird womöglich automatisch gemacht
    // load _serHighScore
    userHighScore = (await _userRepo.getMyHighscore(_gameId))!;
    // load allTimeHighScore
    _allTimeHighScore = (await _userRepo.getHighscore(_gameId))!;

    add(ApeClimberParallaxComponent());

    _monkey = Monkey(_monkeySize, _animationTime)
      ..onMovementFinished = _checkCollision;
    add(_monkey);

    // add tree
    _tree = Tree(this, screenSize, _treeComponentAmount, _animationTime)
      ..width = _monkeySize;
    add(_tree);

    // add branches
    _climberBranches =
        ClimberBranches(this, _monkeySize, _monkeySize / 4, _animationTime)
          ..onBranchesMoved = increaseScore;
    add(_climberBranches);

/*     // initialize Timer Component
    _timer = MonkeyTimer(_onTimerFinished)
      ..onWidgetUpdated = _onTimerWidgetUpdated; */

    _timer = MonkeyTimer(period: 1);
    add(_timer);

    // start timer
    _timer.start();

/*    
        addWidgetOverlay(
        startWidgetName,
        MonkeyStartWidget(
            userHighScore: _userHighScore,
            alltimeHighScore: _allTimeHighScore,
            onStartPressed: _startGame)); */

    /*     initialise Text for Points and timer */
    pointsText = TextPaint(
        style: TextStyle(
            fontSize: screenSize.width * 0.05,
            fontWeight: FontWeight.bold,
            color: score >= userHighScore && score != 0
                ? LamaColors.greenAccent
                : LamaColors.redAccent));

    timeText = TextPaint(
        style: TextStyle(
            fontSize: screenSize.width * 0.05,
            fontWeight: FontWeight.bold,
            color: score >= userHighScore && score != 0
                ? LamaColors.greenAccent
                : LamaColors.redAccent));
  }

  /// This method increase the score as well as the score widget.
  void increaseScore() {
    score += 1;
    // _updateScoreWidget();
  }

  /// This method decrease the score as well as the score widget.
  void decreaseScore() {
    score -= 1;
/*     _updateScoreWidget();
 */
  }

  void decreaseTime() {
    time -= 1;
/*     _updateScoreWidget();
 */
  }

  /// This methods updates the score widget.
  void _updateScoreWidget() {
    if (!_running) {
      return;
    }
/*         removeWidgetOverlay(scoreWidgetName);
    addWidgetOverlay(
        scoreWidgetName, MonkeyScoreWidget(text: score.toString())); */
  }

  /// This method is the handler when the timer finished.
  void _onTimerFinished(MonkeyTimerWidget widget) {
/*     removeWidgetOverlay(timerWidgetName);
    addWidgetOverlay(timerWidgetName, widget); */

    _gameOver("Zeit abgelaufen!!");
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    screenSize = Size(
        MediaQuery.of(_context).size.width -
            MediaQuery.of(_context).padding.left -
            MediaQuery.of(_context).padding.right,
        MediaQuery.of(_context).size.height -
            MediaQuery.of(_context).padding.top -
            MediaQuery.of(_context).padding.bottom);

    branchSize = screenSize.width / tilesX;

    super.onGameResize(canvasSize);
  }

  void render(Canvas c) {
    super.render(c);
    showPoints(c);
    showTime(c);
  }

  void showPoints(Canvas canvas) {
    pointsText.render(canvas, "Punkte:  $score",
        Vector2(screenSize.width * 0.25, screenSize.height * 1 / 35),
        anchor: Anchor.center);
  }

  void showTime(Canvas canvas) {
    timeText.render(canvas, "Punkte:  $time",
        Vector2(screenSize.width * 0.75, screenSize.height * 1 / 35),
        anchor: Anchor.center);
  }

  @override
  void update(double t) {
    // check input queue to select the next movement
    if (_monkey != null && !_monkey.isMoving && _inputQueue.isNotEmpty) {
      /*    components
          .whereType<Monkey>()
          .forEach((element) => element.move(_inputQueue.removeLast())); */

      // _moveBackground();

      // move the tree
      _tree.move(_monkeySize);
      // move the branches
      _climberBranches.move(_monkeySize);
      //das ist neu und sorgt dafür, dass der alte Input nicht in einer dauerschleife verarbeitet wird
      _inputQueue.clear();
    }

    // background y animation on movement
/*     if (_backMoving) {
      if (_backgroundMoveTimeLeft > 0) {
        _back.layerDelta = Offset(6, -6);
        _backgroundMoveTimeLeft -= t;
      } else {
        _backMoving = false;
        _back.layerDelta = Offset(6, 0);
      }
    } */

    super.update(t);
  }

  /// This method checks if the monkey collides with the collision branch.
  void _checkCollision() {
    try {
      if (_monkey.isLeft == _climberBranches.isLeft) {
        print("AST BERÜPHRT");
        //decreaseScore();
        _climberBranches.highlightCollisionBranch();
        _timer.pause();
        _gameOver("Ast berührt!!");
      }
    } on StateError {
      print("[Error] _checkCollision : monkey not found");
    }
  }

  /// This method finishes the game.
  ///
  /// sideffects:
  ///   adds [MonkeyEndscreenWidget] widget
  void _gameOver(String endText) {
    _running = false;
    pauseEngine();

/*     _saveHighScore();

    removeWidgetOverlay(scoreWidgetName);
    addWidgetOverlay(
        endScreenWidgetName,
        MonkeyEndscreenWidget(
          text: endText,
          score: score,
          onQuitPressed: _quit,
        ));

    // removed the playMode widget
    removeWidgetOverlay(playPauseWidgetName); */
  }

  void onTapDown(TapDownInfo info) {
    print("tapDown");
    if (_running) {
      info.eventPosition.global.x < screenSize.width / 2
          ? _monkey.move(ClimbSide.Left)
          : _monkey.move(ClimbSide.Right);
      // add input to queue
      _inputQueue.addFirst(info.eventPosition.global.x < screenSize.width / 2
          ? ClimbSide.Left
          : ClimbSide.Right);
    }
  }
}
