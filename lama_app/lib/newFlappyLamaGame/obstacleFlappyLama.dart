import 'dart:math';
import 'dart:ui';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
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

class ObstacleComp extends FlameGame with HasGameRef {
  late SpriteComponent kaktusTopComponent;
  late SpriteComponent kaktusBodyComponent;
  late SpriteComponent kaktusBottomComponent;

  var obstacleTopEndImage = 'png/kaktus_end_top.png';
  var obstacleBottomEndImage = 'png/kaktus_end_bottom.png';
  var obstacleBodyImage = 'png/kaktus_body.png';

  /// amount of tiles = size of the sprites / width of the obstacle
  final double _sizeInTiles = 1.5;

  /// amount of tiles on the x coordinate
  final int tilesX = 9;

  final FlappyLamaGame2 _game;
  final Vector2 velocity;

  late Size screenSize;

  /// pixel of the quadratic tiles
  late double tileSize = 200;

  ObstacleComp(this._game, this.velocity, BuildContext _context) {
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
    double obstacleYPos = (tileSize * _sizeInTiles) * 0;
    kaktusBottomComponent = SpriteComponent(
      sprite: await gameRef.loadSprite(obstacleBottomEndImage),
      position: Vector2(screenSize.width, obstacleYPos),
      size: Vector2(tileSize * _sizeInTiles, tileSize * _sizeInTiles),
      anchor: Anchor.topLeft,
    );

    obstacleYPos = (tileSize * _sizeInTiles) * 1;
    kaktusBodyComponent = SpriteComponent(
      sprite: await gameRef.loadSprite(obstacleBodyImage),
      position: Vector2(screenSize.width, obstacleYPos),
      size: Vector2(tileSize * _sizeInTiles, tileSize * _sizeInTiles),
      anchor: Anchor.topLeft,
    );

    obstacleYPos = (tileSize * _sizeInTiles) * 2;
    kaktusTopComponent = SpriteComponent(
      sprite: await gameRef.loadSprite(obstacleTopEndImage),
      position: Vector2(screenSize.width, obstacleYPos),
      size: Vector2(tileSize * _sizeInTiles, tileSize * _sizeInTiles),
      anchor: Anchor.topLeft,
    );
    add(kaktusBodyComponent);
    add(kaktusBottomComponent);
    add(kaktusTopComponent);
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);
    kaktusBottomComponent.x -= 10 * dt;
    kaktusBodyComponent.x -= 10 * dt;
    kaktusTopComponent.x -= 10 * dt;
  }
}
