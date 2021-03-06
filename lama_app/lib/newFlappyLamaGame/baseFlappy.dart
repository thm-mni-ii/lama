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
import 'package:lama_app/newFlappyLamaGame/obstacleFlappyLama.dart';

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

import 'newObstacleTry.dart';
import 'obstacleTest.dart';

class FlappyLamaGame2 extends FlameGame
    with TapDetector, HasCollisionDetection {
  /// amount of tiles = size of the sprites / width of the obstacle
  final double _sizeInTiles = 1.5;
  late AnimatedComponent userLama;
  late PositionComponent obst1;
  late PositionComponent obst2;

  /// obstacle list
  List<ObstacleCompNewTry> obstacles = [];

  /// obstacle list
  List<ObstacleCompNewTry> obstaclesChilds = [];

  /// obstacle list
  List<ObstacleCompTest> obstaclesPre = [];

  //Obstacle Stuff
/*   var amountObstaclesPerColumn = 3;
  var obstacleTopEndList = <Obstacle5>[];
  var obstacleBottomEndList = <Obstacle5>[];
  var obstacleBodyList = <Obstacle5>[];
  static double obstacleSize = 0.0;

  Obstacle5 obstacleTopEnd = Obstacle5(false);
  Obstacle5 obstacleBottomEnd = Obstacle5(false);
  Obstacle5 obstacleBody = Obstacle5(false); */

  double xTopEnd = 50;
  double xBottomEnd = 100;
  double xBody = 200;
  double yPosObstacle = 250;

  var obstacleTopEndImage = 'png/kaktus_end_top.png';
  var obstacleBottomEndImage = 'png/kaktus_end_bottom.png';
  var obstacleBodyImage = 'png/kaktus_body.png';

  var obstacleProbability = .3;
  var obstacleFirstColumExisting = false;
  var obstacleThirdColumnExisting = false;

  var velocity1;
  var velocity2;
  var referenceVelocity;

  /// amount of tiles on the x coordinate
  final int tilesX = 9;

  //###########################Obstacle Stuff End

  //
  /// score where the difficulty will increase
  final int _difficultyScore = 5;

  /// the id of flappyLama game which is used in the database
  final int _gameId = 2;

  /// obstacle list
  //List<FlappyObstacle> obstacles = [];

  /// the achieved score in this round
  int score = 0;

  double y = 120;

  /// size of the lama
  final double _lamaSize = 48;

  /// screensize of the game
  late Size _screenSize;

  double xComponent = 200;
  double yComponent = 200;

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
  int? _tilesY;

  /// Getter of [_tilesY]
  int get tilesY {
    return _tilesY!;
  }

  /// Getter of [_tileSize]
  double get tileSize {
    return _tileSize;
  }

  /// the lama [AnimationComponent]

  late AnimatedComponent _lama2;

  /// necessary context for determine the actual screensize
  BuildContext _context;

  /// the [UserRepository] to interact with the database and get the user infos
  UserRepository _userRepo;

  FlappyLamaGame2(this._context, this._userRepo) {
    // load all obstacle pngs
    Flame.images.loadAll([
      'png/kaktus_body.png',
      'png/kaktus_end_bottom.png',
      'png/kaktus_end_top.png',
    ]);
    initializeAsync();
  }

  void loadStartScreenAsync() async {}

  /// This method load the [Size] of the screen and loads the StartScreen
  void initializeAsync() async {
    // resize();
    // resize(_context);

    loadStartScreenAsync();
  }
/* @override
  void onTapDown(TapDownInfo info) {
    if (_started) {
      _lama.onTapDown(info);
    }
  } */

  void onGameResize(Vector2 size) {
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
    print("_tilesY = $_tilesY");
    print("_tilesY = $_tilesY");

    super.onGameResize(size);
    //  super.resize(size);
  }

  var testuse = true;
  @override
  Future<void> update(double dt) async {
    super.update(dt);

    /*    if (obstacles[0].position.x <= -(screenSize.width + 50)) {
      remove(obstacles[0]);
      obstacles[0] = ObstacleCompNewTry(
          this,
          Vector2(0, 0),
          false,
          Vector2(tileSize * _sizeInTiles, tileSize * _sizeInTiles),
          _context,
          tileSize,
          screenSize);
      add(obstacles[0]);
    }

    if (obstacles[1].position.x <= -(screenSize.width + 50)) {
      remove(obstacles[1]);
      obstacles[1] = ObstacleCompNewTry(
          this,
          Vector2(0, 0),
          false,
          Vector2(tileSize * _sizeInTiles, tileSize * _sizeInTiles),
          _context,
          tileSize,
          screenSize);
      add(obstacles[1]);
    } */

    if (obst1.x <= -(screenSize.width + 50)) {
      remove(obst1);
      obst1 = ObstacleCompNewTry(
          this,
          Vector2(0, 0),
          false,
          Vector2(tileSize * _sizeInTiles, tileSize * _sizeInTiles),
          _context,
          tileSize,
          screenSize);
      add(obst1);
    }

    if ((obst2.x <=
                -(screenSize.width +
                    (tilesX ~/ 2) * tileSize +
                    tileSize * _sizeInTiles +
                    50)) &&
            testuse ||
        !testuse && (obst2.x <= -(screenSize.width + 50))) {
      testuse = false;
      remove(obst2);
      obst2 = ObstacleCompNewTry(
          this,
          Vector2(0, 0),
          false,
          Vector2(tileSize * _sizeInTiles, tileSize * _sizeInTiles),
          _context,
          tileSize,
          screenSize);
      add(obst2);
    }
  }

  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  Future<void> onLoad() async {
    referenceVelocity = screenSize.height / 300;
    velocity1 = referenceVelocity;
    velocity2 = referenceVelocity;
    // load all obstacle pngs
    Flame.images.loadAll([
      'png/kaktus_body.png',
      'png/kaktus_end_bottom.png',
      'png/kaktus_end_top.png',
    ]);

    add(MyParallaxComponent());

    add(ScreenHitbox());
    final componentSize = Vector2(80.0, 90.0);

    userLama = AnimatedComponent(
      _lamaSize,
      this,
      Vector2(0, 0),
      Vector2(150, y),
      componentSize,
    );
    add(userLama);
/* 
    // add obstacles
    obstaclesPre.clear();
    obstaclesPre
        .add(ObstacleCompTest(this, false, _lamaSize, addScore, null, 7, 8));
    obstaclesPre
        .add(ObstacleCompTest(this, true, _lamaSize, addScore, null, 7, 8));

    add(obstaclesPre[0]);
    add(obstaclesPre[1]);

    // add reset function = set the ref hole to constraint the hole size and position
    obstaclesPre[0].onResetting = obstaclesPre[1].setConstraints;
    obstaclesPre[1].onResetting = obstaclesPre[0].setConstraints;

    // initial change the second obstacle to avoid a to large gap
    obstaclesPre[1]
        .setConstraints(obstaclesPre[0].holeIndex, obstaclesPre[0].holeSize);
    obstaclesPre[1].resetObstacle();
    obstaclesPre[0].resetObstacle(); */

    //add(ObstacleComp(this, Vector2(0, 0), _context));
    /*    obstacles.clear();
    obstacles.add(ObstacleCompNewTry(
        this,
        Vector2(0, 0),
        false,
        Vector2(tileSize * _sizeInTiles, tileSize * _sizeInTiles),
        _context,
        tileSize,
        screenSize));
    add(obstacles[0]);

    obstacles.add(ObstacleCompNewTry(
        this,
        Vector2(0, 0),
        true,
        Vector2((tileSize * _sizeInTiles), (tileSize * _sizeInTiles)),
        _context,
        tileSize,
        screenSize));

    add(obstacles[1]); */
    /*  add(ObstacleCompNewTry(this, Vector2(0, 0), Vector2(screenSize.width, 0),
        Vector2(tileSize * _sizeInTiles, tileSize * _sizeInTiles), _context)); */

    obst1 = ObstacleCompNewTry(
        this,
        Vector2(0, 0),
        false,
        Vector2(tileSize * _sizeInTiles, tileSize * _sizeInTiles),
        _context,
        tileSize,
        screenSize);
    add(obst1);
    obst2 = ObstacleCompNewTry(
        this,
        Vector2(0, 0),
        true,
        Vector2(tileSize * _sizeInTiles, tileSize * _sizeInTiles),
        _context,
        tileSize,
        screenSize);
    add(obst2);
  }

  /// This methods adds up the score and changes the holesize depending on the score
  void addScore(ObstacleCompTest obstacle) {
    score++;

    if (score > _difficultyScore) {
      obstacle.maxHoleSize = 3;
      obstacle.minHoleSize = 2;
    }
  }

  void onTap() {}

  void onTapCancel() {}
  void onTapDown(TapDownInfo info) {
    userLama.flap();
  }

  void onTapUp(TapUpInfo info) {}
}
