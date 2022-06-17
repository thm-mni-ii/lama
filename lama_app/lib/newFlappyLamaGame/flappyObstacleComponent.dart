import 'dart:ui';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';

import 'package:flame/sprite.dart';
import 'package:lama_app/flappyLama/flappyLamaGame.dart';
import 'package:lama_app/newFlappyLamaGame/baseFlappy.dart';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

/// This class extends [Component] and describes an obstacle.
/// It will move from the right end to the start and will generate a random hole at a random position each time.
class FlappyObstacle2 extends SpriteComponent
    with CollisionCallbacks, HasGameRef {
  // SETTINGS
  // --------
  /// velocity of the obstacles [negative = right to left; positive = left to right]
  final double _velocity = -70;

  /// amount of tiles = size of the sprites / width of the obstacle
  final double _sizeInTiles = 1.5;

  /// minimum size of the hole = multiples by [_sizeInTiles] {[minHoleSize] * [_sizeInTiles]}
  double? minHoleSize = 2.0;

  /// maximum size of the hole = multiples by [_sizeInTiles] {[maxHoleSize] * [_sizeInTiles]}
  double? maxHoleSize = 3.0;

  /// maximum distance between the different holes
  final int _maxHoleDistance = 3;
  // --------
  // SETTINGS

  /// list of all the single sprites of the component
  List<SpriteComponent> _sprites = [];

  /// first component to get the position data
  late SpriteComponent _first;
  late final FlappyLamaGame2 _game;
  final Random _randomNumber = Random();

  //FlappyObstacle2(this._game);

  FlappyObstacle2(
    this._game,
    Vector2 position,
    Vector2 size, {
    double angle = 0,
  }) : super(
        /*     position: position,
          size: size,
          angle: angle,
          anchor: Anchor.center, */
        );

  @override
  Future<void> onLoad() async {
    // reset the sprites
    _sprites = [];

    final sprite = Sprite(await Flame.images.load('png/kaktus_body.png'));

    var tmp = SpriteComponent()
      ..sprite = sprite
      ..height = 50
      ..width = 50
      ..x = 100
      ..y = 100
      ..anchor = Anchor.topLeft;

    //   tmp.sprite = await loadSprite('png/kaktus_end_top.png');
    //Sprite(await Flame.images
    //   .load('png/kaktus_end_top.png')); //'png/kaktus_end_top.png');
    //_sprites.add(tmp);
  }
}
