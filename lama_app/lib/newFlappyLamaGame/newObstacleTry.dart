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
  late SpriteComponent kaktusBottomComponent;

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
  double minHoleSize = 2;

  /// maximum size of the hole = multiples by [_sizeInTiles] {[maxHoleSize] * [_sizeInTiles]}
  double maxHoleSize = 3;

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

  /// list of all the single sprites of the component
  late List<Component> _sprites = [];

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

  Size screenSize;

  ObstacleCompNewTry(
    this._game,
    this.velocity,
    Vector2 position,
    Vector2 size,
    BuildContext _context,
    this.tileSize,
    this.screenSize,
  ) : super(
          position: position,
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

    position.y = (tileSize * _sizeInTiles) * 0 - size.y;

    kaktusBottomComponent = SpriteComponent(
      sprite: await gameRef.loadSprite(obstacleBottomEndImage),
      position: position,
      size: size,
      anchor: Anchor.topLeft,
    );

    position.y = (tileSize * _sizeInTiles) * 1 - size.y;
    kaktusBodyComponent = SpriteComponent(
      sprite: await gameRef.loadSprite(obstacleBodyImage),
      position: position,
      size: size,
      anchor: Anchor.topLeft,
    );
    position.y = (tileSize * _sizeInTiles) * 1 + size.y;
    _sprites.add(kaktusBodyComponent);
    position.y = (tileSize * _sizeInTiles) * 1 - 2 * size.y;
    _sprites.add(kaktusBodyComponent);

    position.y = (tileSize * _sizeInTiles) * 2 - size.y;
    kaktusTopComponent = SpriteComponent(
      sprite: await gameRef.loadSprite(obstacleTopEndImage),
      position: position,
      size: size,
      anchor: Anchor.topLeft,
    );
    add(kaktusBodyComponent);
    ////////////////////////////////////////////////////////////
    ///
    ///
    final hitboxPaint = BasicPalette.white.paint();
    // ..style = PaintingStyle.stroke;
    add(PolygonHitbox.relative(
      [
        Vector2(-2.0, 0.0),
        Vector2(-2.0, -2.0),
        Vector2(0.0, -2.0),
        Vector2(0.0, 0.0),
      ],
      position: Vector2(kaktusBodyComponent.x, kaktusBodyComponent.y),
      parentSize: kaktusBodyComponent.size,
    ));
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
    ));
    /*    add(_sprites[0]);
    add(_sprites[1]); */
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);
    position.x += _velocity * dt;

    if (position.x < -(screenSize.width + 50)) {
      position.x = 100;
    }
    /* kaktusBodyComponent.x -= 100 * dt;
    kaktusTopComponent.x -= 100 * dt; */
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    print("COOOOOOOOOOOOKISIIIIIIIIIIIIIOOOON");
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
