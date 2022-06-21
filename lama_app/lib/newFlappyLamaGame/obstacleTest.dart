import 'dart:collection';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';

import 'baseFlappy.dart';

import 'dart:ui';
import 'dart:developer' as developer;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

class ObstacleFlappy extends SpriteComponent with HasGameRef {
  late SpriteComponent kaktusComponent1;

  /// width and height of the lama in pixel
  final double _size;
  final FlappyLamaGame2 _game;

  ObstacleFlappy(
    this._size,
    this._game,
    Vector2 position,
    Vector2 size, {
    double angle = 0,
  }) : super(
          position: position,
          size: size,
          angle: angle,
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    Sprite sprite = Sprite(await Flame.images.load('png/kaktus_end_top.png'));
    kaktusComponent1 = (SpriteComponent(
      sprite: sprite,
      position: Vector2(150, 200),
      size: Vector2(24.0, 24.0),
      anchor: Anchor.topLeft,
    ));

    // add(kaktus);
  }

/*   @override
  void update(double dt) {
    super.update(dt);
  } */
}

/* class Obstacle2 extends SpriteComponent with HasGameRef {
  Obstacle2();
  late Sprite kaktus1;
  late SpriteComponent kaktusComponent1;

  Future<void> onLoad() async {
    kaktus1 = Sprite(await Flame.images.load('png/kaktus_body.png'),
        srcSize: Vector2(24.0, 24.0), srcPosition: Vector2(150, 200));
    kaktusComponent1 = SpriteComponent(sprite: kaktus1);
  }
} */
