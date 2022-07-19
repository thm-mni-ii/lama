import 'dart:math';
import 'dart:ui';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/animation.dart';

import 'baseFlappy.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

//add(ObstacleComp(this, Vector2(0, 0), Vector2(screenSize.width, 0),
//     Vector2(tileSize * _sizeInTiles, tileSize * _sizeInTiles), _context));
class ObstacleCompNewTry extends PositionComponent
    with HasGameRef, CollisionCallbacks {
  late SpriteComponent kaktusTopComponent;
  late SpriteComponent kaktusBodyComponent;
  late SpriteComponent kaktusBodyComponent2;
  late SpriteComponent kaktusBodyComponent3;
  late SpriteComponent kaktusBottomComponent;
  late SpriteComponent tmp;

  /// list of all the single sprites of the component
  late List<SpriteComponent> _sprites = [];

  var obstacleTopEndImage = 'png/kaktus_end_top.png';
  var obstacleBottomEndImage = 'png/kaktus_end_bottom.png';
  var obstacleBodyImage = 'png/kaktus_body.png';
  // SETTINGS
  // --------
  /// velocity of the obstacles [negative = right to left; positive = left to right]
  final double _velocity = -70;

  /// amount of tiles = size of the sprites / width of the obstacle
  final double _sizeInTiles = 1.5;

  /// minimum size of the hole = multiples by [_sizeInTiles] {[minHoleSize] * [_sizeInTiles]}
  double minHoleSize = 7; //2 wenns schwerer wird

  /// maximum size of the hole = multiples by [_sizeInTiles] {[maxHoleSize] * [_sizeInTiles]}
  double maxHoleSize = 8; //3 wenns schwerer wird

  /// maximum distance between the different holes
  final int _maxHoleDistance = 3;
  // --------
  // SETTINGS

  //FUNCTIONS
  // --------
  /// This function gets called when [_passingObjectX] passes this obstacles X coordinate
/*   Function(FlappyObstacle) onPassing;

  /// This function gets called when an [Rect] collides with this obstacle in [collides]
  Function onCollide;

  /// This function gets called when the obstacle gets reset (holeIndex, holeSize).
  Function(int, int) onResetting; */
  // --------
  //FUNCTIONS

  /// first component to get the position data
  late PositionComponent _first;

  int? _refHoleIndex;
  int? _refHoleSize;

  /// actual size of the hole = multiples by [_sizeInTiles] {[_holeSize] * [_sizeInTiles]}
  int? _holeSize;

  /// hole Index (index of the start of the hole)
  int? _holeIndex;

  /// the x Coordinate of the object which will gets checked for passing in [_checkPassingObject]
  late final double _passingObjectX;

  /// alter start location (true = starts at 1.5 screenwidth; false = start at 1.0 screenwidth)
  bool? _alter;

  get holeIndex {
    return _holeIndex;
  }

  get holeSize {
    return _holeSize;
  }

  final Random _randomNumber = Random();

////////////////////////////////////////////
  ///
  /// pixel of the quadratic tiles
  double tileSize;

  /// amount of tiles on the x coordinate
  final int tilesX = 9;

  final FlappyLamaGame2 _game;
  final Vector2 velocity;
  Iterable<Component>? children2;

  Size screenSize;

  ObstacleCompNewTry(
    this._game,
    this.velocity,
    this._alter,
    Vector2 size,
    BuildContext _context,
    this.tileSize,
    this.screenSize,
    this.maxHoleSize,
    this.minHoleSize,
  ) : super(
          size: size,
          anchor: Anchor.center,
        ) {
/*     screenSize = Size(
        MediaQuery.of(_context).size.width -
            MediaQuery.of(_context).padding.left -
            MediaQuery.of(_context).padding.right,
        MediaQuery.of(_context).size.height -
            MediaQuery.of(_context).padding.top -
            MediaQuery.of(_context).padding.bottom);
    // calculates by the width of the screen
    tileSize = screenSize.width / tilesX;
    var _tilesY = screenSize.height ~/ tileSize; */
  }

  @override
  Future<void> onLoad() async {
    _sprites = [];
    _generateHole();

    final hitboxPaint = BasicPalette.white.paint();

    tmp = SpriteComponent()
      ..sprite = await gameRef.loadSprite(obstacleTopEndImage)
      ..height = _game.tileSize * _sizeInTiles
      ..width = _game.tileSize * _sizeInTiles
      ..x = _game.screenSize.width +
          (_alter!
              ? (_game.tilesX ~/ 2) * _game.tileSize +
                  _game.tileSize * _sizeInTiles
              : 0)
      ..y = (_game.tileSize * _sizeInTiles) * 0
      ..anchor = Anchor.topLeft;

    final fixedLengthList = new List<SpriteComponent>.filled(20, tmp);

    for (int i = 0; i < (this._game.tilesY / this._sizeInTiles); i++) {
      // start of the hole
      if (_holeIndex == i + 1) {
        tmp = SpriteComponent()
          ..sprite = await gameRef.loadSprite(obstacleTopEndImage)
          ..height = _game.tileSize * _sizeInTiles
          ..width = _game.tileSize * _sizeInTiles
          ..x = _game.screenSize.width +
              (_alter!
                  ? (_game.tilesX ~/ 2) * _game.tileSize +
                      _game.tileSize * _sizeInTiles
                  : 0)
          ..y = (_game.tileSize * _sizeInTiles) * i - size.y
          ..anchor = Anchor.topLeft;
        fixedLengthList[i] = tmp;
        if (fixedLengthList[i].isLoaded) {
          remove(fixedLengthList[i]);
        }
        add(fixedLengthList[i]);
        add(PolygonHitbox.relative(
          [
            Vector2(-2.0, 0.0),
            Vector2(-2.0, -2.0),
            Vector2(0.0, -2.0),
            Vector2(0.0, 0.0),
          ],
          position: Vector2(fixedLengthList[i].x, fixedLengthList[i].y),
          parentSize: fixedLengthList[i].size,
        )
            /*  ..paint = hitboxPaint
            ..renderShape = true, */
            );
      }
      // end of the hole
      else if (_holeIndex! + _holeSize! == i) {
        tmp = SpriteComponent()
          ..sprite = await gameRef.loadSprite(obstacleBottomEndImage)
          ..height = _game.tileSize * _sizeInTiles
          ..width = _game.tileSize * _sizeInTiles
          ..x = _game.screenSize.width +
              (_alter!
                  ? (_game.tilesX ~/ 2) * _game.tileSize +
                      _game.tileSize * _sizeInTiles
                  : 0)
          ..y = (_game.tileSize * _sizeInTiles) * i - size.y
          ..anchor = Anchor.topLeft;
        fixedLengthList[i] = tmp;

        add(fixedLengthList[i]);
        add(PolygonHitbox.relative(
          [
            Vector2(-2.0, 0.0),
            Vector2(-2.0, -2.0),
            Vector2(0.0, -2.0),
            Vector2(0.0, 0.0),
          ],
          position: Vector2(fixedLengthList[i].x, fixedLengthList[i].y),
          parentSize: fixedLengthList[i].size,
        ));
      }
      // body of the obstacle
      else if (!(i >= _holeIndex! && i <= _holeIndex! + _holeSize!)) {
        tmp = SpriteComponent()
          ..sprite = await gameRef.loadSprite(obstacleBodyImage)
          ..height = _game.tileSize * _sizeInTiles
          ..width = _game.tileSize * _sizeInTiles
          ..x = _game.screenSize.width +
              (_alter!
                  ? (_game.tilesX ~/ 2) * _game.tileSize +
                      _game.tileSize * _sizeInTiles
                  : 0)
          ..y = (_game.tileSize * _sizeInTiles) * i - size.y
          ..anchor = Anchor.topLeft;
        fixedLengthList[i] = tmp;

        add(fixedLengthList[i]);
        add(PolygonHitbox.relative(
          [
            Vector2(-2.0, 0.0),
            Vector2(-2.0, -2.0),
            Vector2(0.0, -2.0),
            Vector2(0.0, 0.0),
          ],
          position: Vector2(fixedLengthList[i].x, fixedLengthList[i].y),
          parentSize: fixedLengthList[i].size,
        ));
      }
    }
    //sets the position for all Sprite Components
    position.y = (tileSize * _sizeInTiles) * 2 - size.y;
    /*  kaktusBottomComponent = SpriteComponent(
      sprite: await gameRef.loadSprite(obstacleBottomEndImage),
      position: Vector2(position.x, (tileSize * _sizeInTiles) * 0 - size.y),
      size: size,
      anchor: Anchor.topLeft,
    );

    for (int i = 1; i < 4; i++) {
      tmp = SpriteComponent(
        sprite: await gameRef.loadSprite(obstacleBodyImage),
        position: Vector2(position.x, (tileSize * _sizeInTiles) * i - size.y),
        size: size,
        anchor: Anchor.topLeft,
      );
      _sprites.add(tmp);
      add(_sprites[i - 1]);
      add(PolygonHitbox.relative(
        [
          Vector2(-2.0, 0.0),
          Vector2(-2.0, -2.0),
          Vector2(0.0, -2.0),
          Vector2(0.0, 0.0),
        ],
        position: Vector2(_sprites[i - 1].x, _sprites[i - 1].y),
        parentSize: _sprites[i - 1].size,
      ));
    }

    kaktusTopComponent = SpriteComponent(
      sprite: await gameRef.loadSprite(obstacleTopEndImage),
      position: Vector2(position.x, (tileSize * _sizeInTiles) * 4 - size.y),
      size: size,
      anchor: Anchor.topLeft,
    );

    //sets the position for all Sprite Components
    position.y = (tileSize * _sizeInTiles) * 2 - size.y;

    add(kaktusBottomComponent);
    ////////////////////////////////////////////////////////////
    ///
    ///

    add(PolygonHitbox.relative(
      [
        Vector2(-2.0, 0.0),
        Vector2(-2.0, -2.0),
        Vector2(0.0, -2.0),
        Vector2(0.0, 0.0),
      ],
      position: Vector2(kaktusBottomComponent.x, kaktusBottomComponent.y),
      parentSize: kaktusBottomComponent.size,
    ));
    add(kaktusTopComponent);
    add(PolygonHitbox.relative(
      [
        Vector2(-2.0, 0.0),
        Vector2(-2.0, -2.0),
        Vector2(0.0, -2.0),
        Vector2(0.0, 0.0),
      ],
      position: Vector2(kaktusTopComponent.x, kaktusTopComponent.y),
      parentSize: kaktusTopComponent.size,
    )); */
  }

  /// This method will generate the obstacle [_sprites] for the rendering.
  ///
  /// sideeffects:
  ///   [_sprites]
  Future<void> _createObstacleParts() async {
    _sprites = [];
    _generateHole();

    final hitboxPaint = BasicPalette.white.paint();

    tmp = SpriteComponent()
      ..sprite = await gameRef.loadSprite(obstacleTopEndImage)
      ..height = _game.tileSize * _sizeInTiles
      ..width = _game.tileSize * _sizeInTiles
      ..x = _game.screenSize.width +
          (_alter!
              ? (_game.tilesX ~/ 2) * _game.tileSize +
                  _game.tileSize * _sizeInTiles
              : 0)
      ..y = (_game.tileSize * _sizeInTiles) * 0
      ..anchor = Anchor.topLeft;

    final fixedLengthList = new List<SpriteComponent>.filled(20, tmp);

    for (int i = 0; i < (this._game.tilesY / this._sizeInTiles); i++) {
      // start of the hole
      if (_holeIndex == i + 1) {
        tmp = SpriteComponent()
          ..sprite = await gameRef.loadSprite(obstacleTopEndImage)
          ..height = _game.tileSize * _sizeInTiles
          ..width = _game.tileSize * _sizeInTiles
          ..x = _game.screenSize.width +
              (_alter!
                  ? (_game.tilesX ~/ 2) * _game.tileSize +
                      _game.tileSize * _sizeInTiles
                  : 0)
          ..y = (_game.tileSize * _sizeInTiles) * i - size.y
          ..anchor = Anchor.topLeft;
        fixedLengthList[i] = tmp;
        if (fixedLengthList[i].isLoaded) {
          remove(fixedLengthList[i]);
        }
        add(fixedLengthList[i]);
        add(PolygonHitbox.relative(
          [
            Vector2(-2.0, 0.0),
            Vector2(-2.0, -2.0),
            Vector2(0.0, -2.0),
            Vector2(0.0, 0.0),
          ],
          position: Vector2(fixedLengthList[i].x, fixedLengthList[i].y),
          parentSize: fixedLengthList[i].size,
        )
            /*  ..paint = hitboxPaint
            ..renderShape = true, */
            );
      }
      // end of the hole
      else if (_holeIndex! + _holeSize! == i) {
        tmp = SpriteComponent()
          ..sprite = await gameRef.loadSprite(obstacleBottomEndImage)
          ..height = _game.tileSize * _sizeInTiles
          ..width = _game.tileSize * _sizeInTiles
          ..x = _game.screenSize.width +
              (_alter!
                  ? (_game.tilesX ~/ 2) * _game.tileSize +
                      _game.tileSize * _sizeInTiles
                  : 0)
          ..y = (_game.tileSize * _sizeInTiles) * i - size.y
          ..anchor = Anchor.topLeft;
        fixedLengthList[i] = tmp;
        if (fixedLengthList[i].isLoaded) {
          remove(fixedLengthList[i]);
        }
        add(fixedLengthList[i]);
        add(PolygonHitbox.relative(
          [
            Vector2(-2.0, 0.0),
            Vector2(-2.0, -2.0),
            Vector2(0.0, -2.0),
            Vector2(0.0, 0.0),
          ],
          position: Vector2(fixedLengthList[i].x, fixedLengthList[i].y),
          parentSize: fixedLengthList[i].size,
        ));
      }
      // body of the obstacle
      else if (!(i >= _holeIndex! && i <= _holeIndex! + _holeSize!)) {
        tmp = SpriteComponent()
          ..sprite = await gameRef.loadSprite(obstacleBodyImage)
          ..height = _game.tileSize * _sizeInTiles
          ..width = _game.tileSize * _sizeInTiles
          ..x = _game.screenSize.width +
              (_alter!
                  ? (_game.tilesX ~/ 2) * _game.tileSize +
                      _game.tileSize * _sizeInTiles
                  : 0)
          ..y = (_game.tileSize * _sizeInTiles) * i - size.y
          ..anchor = Anchor.topLeft;
        fixedLengthList[i] = tmp;
        if (fixedLengthList[i].isLoaded) {
          remove(fixedLengthList[i]);
        }
        add(fixedLengthList[i]);
        add(PolygonHitbox.relative(
          [
            Vector2(-2.0, 0.0),
            Vector2(-2.0, -2.0),
            Vector2(0.0, -2.0),
            Vector2(0.0, 0.0),
          ],
          position: Vector2(fixedLengthList[i].x, fixedLengthList[i].y),
          parentSize: fixedLengthList[i].size,
        ));
      }
    }
    //sets the position for all Sprite Components
    position.y = (tileSize * _sizeInTiles) * 2 - size.y;
  }

  void setConstraints(int alterHoleIndex, int alterHoleSize) {
    _refHoleIndex = alterHoleIndex;
    _refHoleSize = alterHoleIndex;
  }

  void resetObstacle() {
    _generateHole();
    _createObstacleParts();
    // run callback
    //   onResetting?.call(_holeIndex, _holeSize);
    //  _objectPassed = false;
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);
    position.x += _velocity * dt;

    /*    if (position.x < -(screenSize.width + 50)) {
      position.x = 100;
    } */
/* 
    if (position.x <= -(screenSize.width + 50)) {
      // remove the initial offset
      _alter = false;

      resetObstacle();
      position.x = 100;
    } */
    /* kaktusBodyComponent.x -= 100 * dt;
    kaktusTopComponent.x -= 100 * dt; */
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    var testpos = position.x;
    print("hiiiit bei  $testpos");
//> -460 bei obst 2
    if (position.x < -207 && position.x > -360) {
      _game.gameOver = true;
    }
  }

  /// This method generate a new hole depending on the [minHoleSize], [maxHoleSize] and [_sizeInTiles].
  ///
  /// sideeffects:
  ///   [_holeIndex]
  ///   [_holeSize]
  void _generateHole() {
    // size of the hole
    _holeSize = _randomNumber
            .nextInt(((maxHoleSize - minHoleSize) / _sizeInTiles).ceil() + 1) +
        (minHoleSize / _sizeInTiles).ceil();

    // index of the position of the hole
    _holeIndex =
        _randomNumber.nextInt((_game.tilesY ~/ _sizeInTiles) - _holeSize!);

    if (_refHoleIndex != null && _refHoleSize != null) {
      // new hole lower ref && Distance to large
      if ((_holeIndex! > _refHoleIndex!) &&
          _holeIndex! - (_refHoleIndex! + _refHoleSize!) > _maxHoleDistance) {
        _holeIndex = (_refHoleIndex! + _refHoleSize!) + _maxHoleDistance > 0
            ? (_refHoleIndex! + _refHoleSize!) + _maxHoleDistance
            : 0;
      }
      // new hole higher ref && Distance to large
      else if ((_holeIndex! < _refHoleIndex!) &&
          _refHoleIndex! - (_holeIndex! + _holeSize!) > _maxHoleDistance) {
        _holeIndex = _refHoleIndex! - _maxHoleDistance > 0
            ? _refHoleIndex! - _holeSize! - _maxHoleDistance
            : 0;
      }
    }
  }
}
