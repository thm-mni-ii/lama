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
import 'package:lama_app/game_snake_aus_iNet/snake_game.dart';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

class ObstacleCompNewTry extends PositionComponent
    with HasGameRef, CollisionCallbacks {
  late SpriteComponent kaktusTopComponent;
  late SpriteComponent kaktusBodyComponent;
  late SpriteComponent kaktusBodyComponent2;
  late SpriteComponent kaktusBodyComponent3;
  late SpriteComponent kaktusBottomComponent;
  late SpriteComponent tmp;

  late PositionComponent lama;

  /// list of all the single sprites of the component
  late List<SpriteComponent> _sprites = [];

  var obstacleTopEndImage = 'png/snake_tail.png';
  var obstacleBottomEndImage = 'png/snake_tail.png';
  var obstacleBodyImage = 'png/snake_tail.png';
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

  /// amount of tiles on the x coordinate
  final int tilesX = 9;

  Iterable<Component>? children2;

  ObstacleCompNewTry()
      : super(
          anchor: Anchor.center,
        ) {}

  @override
  Future<void> onLoad() async {
    _sprites = [];

    final hitboxPaint = BasicPalette.white.paint();

    tmp = SpriteComponent()
      ..sprite = await gameRef.loadSprite(obstacleTopEndImage)
      ..height = 30
      ..width = 30
      ..y = 0
      ..anchor = Anchor.topLeft;

    final fixedLengthList = new List<SpriteComponent>.filled(20, tmp);

    add(tmp);
/*         add(fixedLengthList[i]);
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
            /*     ..paint = hitboxPaint
            ..renderShape = true, */
            ); */
  }

  void setConstraints(int alterHoleIndex, int alterHoleSize) {
    _refHoleIndex = alterHoleIndex;
    _refHoleSize = alterHoleIndex;
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    var testpos = position.x;
    print("hiiiit bei  $testpos");
  }
}
