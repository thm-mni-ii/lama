import 'dart:collection';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/apeClimber/components/treeSprite.dart';

import '../apeClimber/components/climberBranches.dart';
import '../apeClimber/components/tree.dart';
import '../app/repository/user_repository.dart';
import 'backgroundApeClimber.dart';
import 'monkeyComponent.dart';

class ApeClimberGame extends FlameGame with TapDetector {
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
  late int _userHighScore;

  /// the all time highScore in this game
  late int _allTimeHighScore;

  /// the achieved score in this round
  int score = 0;

  late Monkey _monkey;

  Queue<ClimbSide> _inputQueue = Queue();

  /// Tree component
  late Tree _tree;

  late TreeSprite _treeSprite;

/*    
  /// Timer component for display and organize the gametimer.
  MonkeyTimer _timer;


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
    _userHighScore = (await _userRepo.getMyHighscore(_gameId))!;
    // load allTimeHighScore
    _allTimeHighScore = (await _userRepo.getHighscore(_gameId))!;

    add(ApeClimberParallaxComponent());

    _monkey = Monkey(_monkeySize, _animationTime)
      ..onMovementFinished = _checkCollision;
    add(_monkey);

    // add tree
    _tree = Tree(screenSize, _treeComponentAmount, _animationTime)
      ..width = _monkeySize;
    add(_tree);

    // add branches
    _climberBranches =
        ClimberBranches(this, _monkeySize, _monkeySize / 4, _animationTime)
          ..onBranchesMoved = increaseScore;
    add(_climberBranches);

/*    
        addWidgetOverlay(
        startWidgetName,
        MonkeyStartWidget(
            userHighScore: _userHighScore,
            alltimeHighScore: _allTimeHighScore,
            onStartPressed: _startGame)); */
  }

  /// This method increase the score as well as the score widget.
  void increaseScore() {
    score += 1;
    // _updateScoreWidget();
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
        //decreaseScore();
        _climberBranches.highlightCollisionBranch();
/*         _timer.pause();
        _gameOver("Ast berührt!!"); */
      }
    } on StateError {
      print("[Error] _checkCollision : monkey not found");
    }
  }

  void onTapDown(TapDownInfo info) {
    print("tapDown");
    if (_running) {
      // add input to queue
      _inputQueue.addFirst(info.eventPosition.global.x < screenSize.width / 2
          ? ClimbSide.Left
          : ClimbSide.Right);
    }
  }
}
