import 'dart:collection';

import 'package:flame/gestures.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/components/parallax_component.dart';

import 'package:flutter/material.dart';
import 'package:lama_app/apeClimber/components/monkeyTimer.dart';
import 'package:lama_app/apeClimber/components/monkey.dart';
import 'package:lama_app/apeClimber/widgets/PlayPauseModeWidget.dart';
import 'package:lama_app/apeClimber/widgets/monkeyScoreWidget.dart';
import 'package:lama_app/apeClimber/widgets/monkeyStartWidget.dart';
import 'package:lama_app/apeClimber/widgets/monkeyTimerWidget.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/app/model/highscore_model.dart';
import 'package:lama_app/apeClimber/components/climberBranches.dart';
import '../app/screens/game_list_screen.dart';
import 'widgets/monkeyEndscreenWidget.dart';
import 'components/tree.dart';

/// This class represents the monkey climber game and its components.
class ClimberGame extends BaseGame with TapDetector, HasWidgetsOverlay {
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

  Monkey _monkey;
  Queue<ClimbSide> _inputQueue = Queue();

  /// Timer component for display and organize the gametimer.
  MonkeyTimer _timer;

  /// flag which indicates if the game is running
  bool _running = false;

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

  /// Tree component
  Tree _tree;

  /// Size of the screen
  Size screenSize;

  /// Background component
  ParallaxComponent _back;

  /// flag if the background is moving
  bool _backMoving = false;

  /// pixel left which the background has to move
  ClimberBranches _climberBranches;
  double branchSize;

  /// time left for the animation of the background
  double _backgroundMoveTimeLeft = 0;

  /// the [UserRepository] to interact with the database and get the user infos
  UserRepository _userRepo;

  ClimberGame(this._context, this._userRepo) {
    _back = ParallaxComponent([
      ParallaxImage('png/himmel.png'),
      ParallaxImage('png/clouds_3.png'),
      ParallaxImage('png/clouds_2.png'),
      ParallaxImage('png/clouds.png'),
    ], baseSpeed: Offset(3, 0), layerDelta: Offset(6, 0));

    Flame.images.loadAll([
      'png/tree7th.png',
      'png/tree7th2.png',
      'png/stick_3.png',
    ]);

    initialize();
  }

  /// This method load the [Size] of the screen, highscore and loads the StartScreen
  void initialize() async {
    resize(await Flame.util.initialDimensions());
    // load _serHighScore
    _userHighScore = await _userRepo.getMyHighscore(_gameId);
    // load allTimeHighScore
    _allTimeHighScore = await _userRepo.getHighscore(_gameId);

    // add Background
    add(_back);

    // add tree
    _tree = Tree(_treeComponentAmount, _animationTime)..width = _monkeySize;
    add(_tree);

    addWidgetOverlay(
        startWidgetName,
        MonkeyStartWidget(
            userHighScore: _userHighScore,
            alltimeHighScore: _allTimeHighScore,
            onStartPressed: _startGame));
  }

  /// This method increase the score as well as the score widget.
  void increaseScore() {
    score += 1;
    _updateScoreWidget();
  }

  /// This method decrease the score as well as the score widget.
  void decreaseScore() {
    score -= 1;
    _updateScoreWidget();
  }

  /// This methods updates the score widget.
  void _updateScoreWidget() {
    if (!_running) {
      return;
    }

    removeWidgetOverlay(scoreWidgetName);
    addWidgetOverlay(
        scoreWidgetName, MonkeyScoreWidget(text: score.toString()));
  }

  /// This method checks if the monkey collides with the collision branch.
  void _checkCollision() {
    try {
      if (_monkey.isLeft == _climberBranches.isLeft) {
        //decreaseScore();
        _climberBranches.highlightCollisionBranch();
        _timer.pause();
        _gameOver("Ast berührt!!");
      }
    } on StateError {
      print("[Error] _checkCollision : monkey not found");
    }
  }

  /// This method initialize the components and removes the start widget.
  void _startGame() {
    if (_userRepo.getLamaCoins() < GameListScreen.games[_gameId - 1].cost) {
      Navigator.pop(_context, "NotEnoughCoins");
      return;
    }
    _userRepo.removeLamaCoins(GameListScreen.games[_gameId - 1].cost);
    _addGameComponents();
    removeWidgetOverlay(startWidgetName);
    addWidgetOverlay(
        scoreWidgetName, MonkeyScoreWidget(text: score.toString()));

    addWidgetOverlay(playPauseWidgetName,
        PlayPauseModeWidget(playMode: true, onButtonPressed: _pauseGame));

    _running = true;
  }

  /// This method pauses the game.
  void _pauseGame() {
    pauseEngine();

    // removed the playMode widget
    removeWidgetOverlay(playPauseWidgetName);
    addWidgetOverlay(playPauseWidgetName,
        PlayPauseModeWidget(playMode: false, onButtonPressed: _resumeGame));

    _running = false;
  }

  /// This method resumes the game.
  void _resumeGame() {
    resumeEngine();

    // remove the pauseMode widget
    removeWidgetOverlay(playPauseWidgetName);

    // add the playMode widget
    addWidgetOverlay(playPauseWidgetName,
        PlayPauseModeWidget(playMode: true, onButtonPressed: _pauseGame));

    _running = true;
  }

  /// This method adds all components which are necessary to the game.
  void _addGameComponents() {
    // remove monkey and timer
    components.whereType<Monkey>().forEach((element) => element.destroy());
    components.whereType<MonkeyTimer>().forEach((element) => element.destroy());

    // initialize monkey
    _monkey = Monkey(_monkeySize, _animationTime)
      ..onMovementFinished = _checkCollision;
    add(_monkey);

    // add branches
    _climberBranches =
        ClimberBranches(this, _monkeySize, _monkeySize / 4, _animationTime)
          ..onBranchesMoved = increaseScore;
    add(_climberBranches);

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

  /// This method finishes the game.
  ///
  /// sideffects:
  ///   adds [MonkeyEndscreenWidget] widget
  void _gameOver(String endText) {
    _running = false;
    pauseEngine();
    _saveHighScore();

    removeWidgetOverlay(scoreWidgetName);
    addWidgetOverlay(
        endScreenWidgetName,
        MonkeyEndscreenWidget(
          text: endText,
          score: score,
          onQuitPressed: _quit,
        ));

    // removed the playMode widget
    removeWidgetOverlay(playPauseWidgetName);
  }

  /// This method closes the game widget.
  void _quit() {
    removeWidgetOverlay(endScreenWidgetName);
    Navigator.pop(_context);
  }

  /// This method is the handler when the timer finished.
  void _onTimerFinished(MonkeyTimerWidget widget) {
    removeWidgetOverlay(timerWidgetName);
    addWidgetOverlay(timerWidgetName, widget);

    _gameOver("Zeit abgelaufen!!");
  }

  /// This method is the handler when the timer finished.
  void _onTimerWidgetUpdated(MonkeyTimerWidget widget) {
    removeWidgetOverlay(timerWidgetName);
    addWidgetOverlay(timerWidgetName, widget);
  }

  /// This method flag the background movement which is handled in [update]
  void _moveBackground() {
    if (_backMoving) {
      return;
    }

    _backMoving = true;
    _backgroundMoveTimeLeft = _animationTime;
  }

  @override
  void update(double t) {
    // check input queue to select the next movement
    if (_monkey != null && !_monkey.isMoving && _inputQueue.isNotEmpty) {
      components
          .whereType<Monkey>()
          .forEach((element) => element.move(_inputQueue.removeLast()));

      _moveBackground();

      // move the tree
      _tree?.move(_monkeySize);
      // move the branches
      _climberBranches.move(_monkeySize);
    }

    // background y animation on movement
    if (_backMoving) {
      if (_backgroundMoveTimeLeft > 0) {
        _back.layerDelta = Offset(6, -6);
        _backgroundMoveTimeLeft -= t;
      } else {
        _backMoving = false;
        _back.layerDelta = Offset(6, 0);
      }
    }

    super.update(t);
  }

  void resize(Size size) {
    screenSize = Size(
        MediaQuery.of(_context).size.width -
            MediaQuery.of(_context).padding.left -
            MediaQuery.of(_context).padding.right,
        MediaQuery.of(_context).size.height -
            MediaQuery.of(_context).padding.top -
            MediaQuery.of(_context).padding.bottom);

    branchSize = screenSize.width / tilesX;

    super.resize(size);
  }

  void render(Canvas c) {
    super.render(c);
  }

  void onTapDown(TapDownDetails d) {
    if (_running) {
      // add input to queue
      _inputQueue.addFirst(d.localPosition.dx < screenSize.width / 2
          ? ClimbSide.Left
          : ClimbSide.Right);
    }
  }
}
