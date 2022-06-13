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

class AnimatedComponent extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef, Tappable {
  final Vector2 velocity;

  late SpriteAnimation _upAnimation;
  late SpriteAnimation _idleAnimation;
  late SpriteAnimation _fallAnimation;
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

  final FlappyLamaGame2 _game;

  /// actual speed of the lama
  double _speedY = 0.0;

  /// gravity of the lama = falling speed
  static const double GRAVITY = 100;

  /// speed increase/decrease when [flap] gets called = flap height
  final double _flapSpeed = -220;

  /// width and height of the lama in pixel
  final double _size;

  AnimatedComponent(
    this._size,
    this._game,
    this.velocity,
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
    // size
    height = _size;
    width = _size;

    animation = await gameRef.loadSpriteAnimation(
      'png/lama_animation.png',
      SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: 0.2,
        textureSize: Vector2.all(24),
      ),
    );
////////////////////////////////////////////////////////////
    ///
    ///
    final spriteSheet = SpriteSheet(
      image: await Flame.images.load('png/lama_animation.png'),
      srcSize: Vector2(24.0, 24.0),
    );

    final spriteSize = Vector2(80.0, 90.0);
    // idle / hover animation
    _idleAnimation =
        spriteSheet.createAnimation(row: 0, from: 0, to: 4, stepTime: 0.1);

    // up animation
    _upAnimation =
        spriteSheet.createAnimation(row: 0, from: 5, to: 8, stepTime: 0.1);

    // fall animation
    _fallAnimation =
        spriteSheet.createAnimation(row: 0, from: 9, to: 12, stepTime: 0.1);

    // start animation

    _upComponent = SpriteAnimationComponent(
      animation: _upAnimation,
      position: Vector2(150, y),
      size: spriteSize,
    );

    _fallComponent = SpriteAnimationComponent(
      animation: _fallAnimation,
      position: Vector2(150, y),
      size: spriteSize,
    );

    _idleComponent = SpriteAnimationComponent(
      animation: _idleAnimation,
      position: Vector2(150, y),
      size: spriteSize,
    );

    ////////////////////////////////////////////////////////////
    ///
    ///
/*     final hitboxPaint = BasicPalette.white.paint()
      ..style = PaintingStyle.stroke;
    add(
      PolygonHitbox.relative(
        [
          Vector2(0.0, -1.0),
          Vector2(-1.0, -0.1),
          Vector2(-0.2, 0.4),
          Vector2(0.2, 0.4),
          Vector2(1.0, -0.1),
        ],
        parentSize: size,
      )
        ..paint = hitboxPaint
        ..renderShape = true,
    ); */
  }

  /// This method let the lama fly up with an impuls.
  ///
  /// sideffects:
  ///   [_speedY] = [_flapSpeed]
  void flap() {
    _speedY = _flapSpeed;
  }

  @override
  void update(double dt) {
    super.update(dt);
    // last y for animation selection
    var lastY = y;

    // speed
    _speedY += GRAVITY * dt;
    // new y
    position.y += _speedY * dt;
    // hits the ground?
/*     if (!isHittingGround()) {
      // hit the top?
      isHittingTop(dt);
    } */
    // choose animation
    if (lastY > y) {
      animation = _upAnimation;
    } else if (lastY < y) {
      animation = _fallAnimation;
    } else {
      animation = _idleAnimation;
    }
  }

////////////////////////////////
  ///tap logic
  ///

  bool _beenPressed = false;

  @override
  bool onTapUp(_) {
    _beenPressed = false;
    return true;
  }

  @override
  bool onTapDown(_) {
    _beenPressed = true;
    // simulates one flap
    flap();
    // position.y -= 300.0;
    return true;
  }

  @override
  bool onTapCancel() {
    _beenPressed = false;
    return true;
  }

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
      onHitTop.call();
      return true;
    }

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
  bool isHittingGround() {
    if (position.y > _game.screenSize.height - _size) {
      // fix the lama
      position.y = _game.screenSize.height - _size;
      // remove the speed
      _speedY = 0.0;
      // callback
      onHitGround.call();
      return true;
    }

    return false;
  }

/*   final Paint hitboxPaint = BasicPalette.green.paint()
    ..style = PaintingStyle.stroke;
  final Paint dotPaint = BasicPalette.red.paint()..style = PaintingStyle.stroke;
 */
/*   @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    velocity.negate();
    flipVertically();
  } */
}
