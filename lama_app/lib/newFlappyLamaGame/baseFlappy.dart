import 'dart:ui';
import 'dart:developer' as developer;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

import 'package:lama_app/app/model/game_model.dart';
import 'package:lama_app/app/model/highscore_model.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/flappyLama/components/flappyLama.dart';
import 'package:lama_app/flappyLama/components/flappyObstacle.dart';
import 'package:lama_app/flappyLama/components/flappyScoreDisplay.dart';
import 'package:lama_app/flappyLama/widgets/playModeWidget.dart';
import 'package:lama_app/flappyLama/widgets/startScreen.dart';
import 'package:lama_app/newFlappyLamaGame/flappyObstacleComponent.dart';
import 'package:lama_app/newFlappyLamaGame/obstacleTest.dart';

import '../app/screens/game_list_screen.dart';
import 'package:flame/events.dart';
//import 'package:lama_app/newFlappyLamaGame/lamaSpriteAnimation.dart';

import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';

import 'CollidableAnimationComponent.dart';
import 'backgroundFlappyLama.dart';
import 'baseAnimationComponent.dart';
import 'flappyObstacleComponent.dart';

class FlappyLamaGame2 extends FlameGame with HasTappables {
  /// score where the difficulty will increase
  final int _difficultyScore = 5;

  /// the id of flappyLama game which is used in the database
  final int _gameId = 2;

  /// amount of tiles on the x coordinate
  final int tilesX = 9;

  /// obstacle list
  List<FlappyObstacle> obstacles = [];

  /// the achieved score in this round
  int score = 0;

  double y = 120;

  /// size of the lama
  final double _lamaSize = 48;

  /// screensize of the game
  late Size _screenSize;

  /// Getter of [_screenSize]
  Size get screenSize {
    return _screenSize;
  }

  /// gravity of the lama = falling speed
  static const double GRAVITY = 1000;
  double _speedY = 0.0;
  @override
  Color backgroundColor() => const Color(0xFFFFFFFF);

  /// a bool flag which indicates if the game has started
  bool _started = true;
  bool get started {
    return _started;
  }

  /// pixel of the quadratic tiles
  late double _tileSize;

  /// amount of tiles on the y coordinate
  late int _tilesY;

  /// Getter of [_tilesY]
  int get tilesY {
    return _tilesY;
  }

  /// Getter of [_tileSize]
  double get tileSize {
    return _tileSize;
  }

  /// the lama [AnimationComponent]
  late LamaAnimationComponent _lama;
  late AnimatedComponent _lama2;

  /// necessary context for determine the actual screensize
  BuildContext _context;

  /// the [UserRepository] to interact with the database and get the user infos
  UserRepository _userRepo;

  FlappyLamaGame2(this._context, this._userRepo) {
    initializeAsync();
  }

  void loadStartScreenAsync() async {
    _lama = LamaAnimationComponent(this, _lamaSize); //..onHitGround = gameOver;
    // add(_lama);
  }

  /// This method load the [Size] of the screen and loads the StartScreen
  void initializeAsync() async {
    // resize();
    resize(_context);

    loadStartScreenAsync();
  }
/* @override
  void onTapDown(TapDownInfo info) {
    if (_started) {
      _lama.onTapDown(info);
    }
  } */

  void resize(_context) {
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

    //  super.resize(size);
  }

  void update(double t) {
    super.update(t);
    //  _lama.y += 150;
  }

  void render(Canvas canvas) {
    // draw the hitboxframe

    super.render(canvas);
  }

  /// This methods adds up the score and changes the holesize depending on the score
  void addScore(FlappyObstacle obstacle) {
    score++;

    if (score > _difficultyScore) {
      obstacle.maxHoleSize = 3;
      obstacle.minHoleSize = 2;
    }
  }

  @override
  Future<void> onLoad() async {
    // load all obstacle pngs
    Flame.images.loadAll([
      'png/kaktus_body.png',
      'png/kaktus_end_bottom.png',
      'png/kaktus_end_top.png',
    ]);

    add(MyParallaxComponent());

/*     // add obstacles
    obstacles.clear();
    obstacles.add(FlappyObstacle(this, false, _lamaSize, addScore, null, 7, 8));
    obstacles.add(FlappyObstacle(this, true, _lamaSize, addScore, null, 7, 8));

    add(obstacles[0]);
    add(obstacles[1]);

    // add reset function = set the ref hole to constraint the hole size and position
    obstacles[0].onResetting = obstacles[1].setConstraints;
    obstacles[1].onResetting = obstacles[0].setConstraints;
//////////////////////////////////////////////////////
    ///temporäre lösung.. but wrong
    // obstacles[0].up(_screenSize);

    // initial change the second obstacle to avoid a to large gap
    obstacles[1].setConstraints(obstacles[0].holeIndex, obstacles[0].holeSize);
    obstacles[1].resetObstacle();
    obstacles[0].resetObstacle(); */

    add(ScreenHitbox());
    final componentSize = Vector2(80.0, 90.0);
    add(SpriteComponent(
      sprite: await loadSprite('png/kaktus_body.png'),
      position: Vector2(150, 200),
      size: Vector2(24.0, 24.0),
      anchor: Anchor.topLeft,
    ));
    add(
      AnimatedComponent(
        _lamaSize,
        this,
        Vector2(0, 0),
        Vector2(150, y),
        componentSize,
      ),
    );

    //add(ObstacleFlappy(_lamaSize * 2, this, Vector2(150, 200), componentSize));
/*     add(
      AnimatedComponent(
        _lamaSize,
        this,
        Vector2(0, 0),
        Vector2(200, y),
        componentSize,
      ),
    ); */
/*    add(FlappyObstacle2(
      this,
      Vector2(0, 0),
      Vector2(200, y),
    )); */
  }
}
