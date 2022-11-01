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

import 'snake_game.dart';

class AnimatedComponent extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<SnakeGame> {
  final Vector2 velocity;

  late SpriteAnimation _upAnimation;
  late SpriteAnimation _leftAnimation;
  late SpriteAnimation _downAnimation;
  late SpriteAnimation _rightAnimation;
  late SpriteAnimation _currentAnimation;

  late SpriteAnimationComponent _upComponent;

  /// animation in flying up mode
  late SpriteAnimationComponent _idleComponent;

  /// animation in falling mode
  late SpriteAnimationComponent _fallComponent;

  /// callback when the lama hits the top
  late Function onHitTop;

  /// callback when the lama hits an object in [collides(Rect object)]
  late Function onCollide;

  /// callback when the lama hits the ground
  late Function onHitGround;

  //final SnakeGame _game;

  /// actual speed of the lama
  double _speedY = 0.0;

  /// gravity of the lama = falling speed
  static const double GRAVITY = 1000;

  /// speed increase/decrease when [flap] gets called = flap height
  final double _flapSpeed = -320;

  /// width and height of the lama in pixel
  final double _size;

  bool boolIsHittingTop = false;

  AnimatedComponent(
    this._size,
    //this._game,
    this.velocity,
    Vector2 position,
    Vector2 size, {
    double angle = 0,
  }) : super(
          position: position,
          size: size,
          angle: angle,
          anchor: Anchor.topLeft,
        );

  @override
  Future<void> onLoad() async {
    // size
    height = 30; //_size;
    width = 30; //_size;

    animation = await gameRef.loadSpriteAnimation(
      'png/snake_head_top.png',
      SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: 0.2,
        textureSize: Vector2.all(30),
      ),
    );
////////////////////////////////////////////////////////////
    ///
    ///
    final spriteSheetup = SpriteSheet(
      image: await Flame.images.load('png/snake_head_top.png'),
      srcSize: Vector2(30.0, 30.0),
    );

    final spriteSheetdown = SpriteSheet(
      image: await Flame.images.load('png/snake_head_down.png'),
      srcSize: Vector2(30.0, 30.0),
    );

    final spriteSheetleft = SpriteSheet(
      image: await Flame.images.load('png/snake_head_left.png'),
      srcSize: Vector2(30.0, 30.0),
    );

    final spriteSheetright = SpriteSheet(
      image: await Flame.images.load('png/snake_head_right.png'),
      srcSize: Vector2(30.0, 30.0),
    );

    final spriteSize = Vector2(60.0, 60.0);
    // idle / hover animation
    _currentAnimation =
        spriteSheetleft.createAnimation(row: 0, from: 0, to: 1, stepTime: 0.1);

    _leftAnimation =
        spriteSheetleft.createAnimation(row: 0, from: 0, to: 1, stepTime: 0.1);

    _rightAnimation =
        spriteSheetright.createAnimation(row: 0, from: 0, to: 1, stepTime: 0.1);

    // up animation
    _upAnimation =
        spriteSheetup.createAnimation(row: 0, from: 0, to: 1, stepTime: 0.1);

    // fall animation
    _downAnimation =
        spriteSheetdown.createAnimation(row: 0, from: 0, to: 1, stepTime: 0.1);

    // start animation

    ////////////////////////////////////////////////////////////
    ///
    ///
    final hitboxPaint = BasicPalette.red.paint()..style = PaintingStyle.stroke;
    add(
      PolygonHitbox.relative(
        [
          Vector2(-1.0, 0.0),
          Vector2(-1.0, -1.0),
          Vector2(0.0, -1.0),
          Vector2(0.0, 0.0),
        ],
        parentSize: spriteSize,
      )
        ..paint = hitboxPaint
        ..renderShape = true,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    animation = _currentAnimation;
  }

  void setDirectionOfAnimation(int a) {
    switch (a) {
      case 0:
        _currentAnimation = _downAnimation;
        break;
      case 1:
        _currentAnimation = _downAnimation;
        break;
      case 2:
        _currentAnimation = _upAnimation;
        break;
      case 3:
        _currentAnimation = _leftAnimation;
        break;
      case 4:
        _currentAnimation = _rightAnimation;
        break;
      default:
    }
  }

////////////////////////////////
  ///tap logic
  ///

//////////////////////////////////
  ///
  /// This method checks if the lama hits the top.
  ///
  /// It need [t] which is the the time since the last update cycle to calculate the speed.
  /// If so the [onHitTop] Function gets called.
  /// return:
  ///   true = hits the top
  ///   false = doesnt hits the top
  /// sideeffects:
  ///   [_speedY] = resets when hitting
  ///   [y]
  bool isHittingTop(double t) {
    if (position.y <= 0) {
      _speedY = 0.0;
      _speedY += GRAVITY * t;
      position.y += _speedY * t;

      // callback
      // onHitTop.call();
      boolIsHittingTop = true;
      return true;
    }
    boolIsHittingTop = false;
    return false;
  }

  /// This method checks if the lama hits the ground.
  ///
  /// If so the [onHitGround] Function gets called.
  /// return:
  ///   true = hits the ground
  ///   false = doesnt hits the ground
  /// sideeffects:
  ///   [_speedY] = 0 when hitting
  ///   [y] = bottom of the screen when hitting
/*   bool isHittingGround() {
/*     if (position.y > _game.screenSize.height - _size) {
      // fix the lama
      position.y = _game.screenSize.height - _size;
      // remove the speed
      _speedY = 0.0;
      print("GROUND HIIIIT");
      _game.gameOver = true;
      // callback
      // onHitGround.call();
      return true;
    }

    return false; */
  } */

/*   final Paint hitboxPaint = BasicPalette.green.paint()
    ..style = PaintingStyle.stroke;
  final Paint dotPaint = BasicPalette.red.paint()..style = PaintingStyle.stroke;
 */
  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    /*    print("LAMA HIT");
    super.onCollisionStart(intersectionPoints, other);
    double test = this.position.y;

    if (position.y > 30) {
      _game.gameOver = true;
    }
    if (position.y > 30) {
      _game.gameOver = true;
    } */
  }
}
