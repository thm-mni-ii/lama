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

  /// pixel of the quadratic tiles
  late double tileSize;

  /// amount of tiles on the x coordinate
  final int tilesX = 9;

  final FlappyLamaGame2 _game;
  final Vector2 velocity;

  late Size screenSize;

  ObstacleCompNewTry(
    this._game,
    this.velocity,
    Vector2 position,
    Vector2 size,
    BuildContext _context,
  ) : super(
          position: position,
          size: size,
          anchor: Anchor.center,
        ) {
    var hitbox = PolygonHitbox.relative(
      [
        Vector2(-1.0, 0.0),
        Vector2(-1.0, -1.0),
        Vector2(0.0, -1.0),
        Vector2(0.0, 0.0),
      ],
      parentSize: size,
    )..renderShape = true;
    // add(hitbox);
    screenSize = Size(
        MediaQuery.of(_context).size.width -
            MediaQuery.of(_context).padding.left -
            MediaQuery.of(_context).padding.right,
        MediaQuery.of(_context).size.height -
            MediaQuery.of(_context).padding.top -
            MediaQuery.of(_context).padding.bottom);
    // calculates by the width of the screen
    tileSize = screenSize.width / tilesX;
    var _tilesY = screenSize.height ~/ tileSize;
  }

  @override
  Future<void> onLoad() async {
    position.y = (tileSize * _sizeInTiles) * 0;

    kaktusBottomComponent = SpriteComponent(
      sprite: await gameRef.loadSprite(obstacleBottomEndImage),
      position: position,
      size: size,
      anchor: Anchor.topLeft,
    );

    position.y = (tileSize * _sizeInTiles) * 1;
    kaktusBodyComponent = SpriteComponent(
      sprite: await gameRef.loadSprite(obstacleBodyImage),
      position: position,
      size: size,
      anchor: Anchor.topLeft,
    );

    position.y = (tileSize * _sizeInTiles) * 2;
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
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);
    position.x -= 100 * dt;
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
}
