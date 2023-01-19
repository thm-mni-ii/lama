import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

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

  late Monkey _monkey;
/*   Queue<ClimbSide> _inputQueue = Queue();
 */
  /// flag which indicates if the game is running
  bool _running = false;

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

/*     Monkey _monkey;
  Queue<ClimbSide> _inputQueue = Queue();

  /// Timer component for display and organize the gametimer.
  MonkeyTimer _timer;

    /// Tree component
  Tree _tree;

    /// Background component
  ParallaxComponent _back;
  
    /// pixel left which the background has to move
  ClimberBranches _climberBranches;
  double branchSize;


   */

  /// the [UserRepository] to interact with the database and get the user infos
  late UserRepository _userRepo;

  /// necessary context for determine the actual screenSize
  BuildContext _context;

  late Size screenSize;

  late double branchSize;

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

    _monkey = Monkey(
        _monkeySize, _animationTime); // ..onMovementFinished = _checkCollision;
    add(_monkey);

/*          // add tree
    _tree = Tree(_treeComponentAmount, _animationTime)..width = _monkeySize;
    add(_tree);

        addWidgetOverlay(
        startWidgetName,
        MonkeyStartWidget(
            userHighScore: _userHighScore,
            alltimeHighScore: _allTimeHighScore,
            onStartPressed: _startGame)); */
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

  void onTapDown(TapDownInfo info) {
/*     if (_running) {
      // add input to queue
      _inputQueue.addFirst(d.localPosition.dx < screenSize.width / 2
          ? ClimbSide.Left
          : ClimbSide.Right);
    } */
  }
}
