import 'dart:ui';
import 'dart:ui';

import 'package:flame/components.dart';

import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/animation.dart';

import 'baseFlappy.dart';

class LamaAnimationComponent extends SpriteAnimationComponent
    with HasGameRef<FlappyLamaGame2> {
  // final Vector2 velocity;
  late SpriteAnimation _upAnimation;
  late SpriteAnimation _idleAnimation;

  late SpriteAnimation _fallAnimation;

  bool testUp = false;
  // SETTINGS
  // --------
  /// hitbox padding = [left, right, top, bottom] = negative move inwards / positive move outwards
  final _hitBoxPadding = [-9.0, -7.0, -7.0, -3.0];

  /// flag to show the hitbox as an rectangle
  final bool _showHitbox = false;

  /// speed increase/decrease when [flap] gets called = flap height
  final double _flapSpeed = -320;

  /// gravity of the lama = falling speed
  static const double GRAVITY = 1000;
  // --------
  /// callback when the lama hits an object in [collides(Rect object)]
  late Function onCollide;

  /// callback when the lama hits the ground
  late Function onHitGround;

  /// callback when the lama hits the top
  late Function onHitTop;

  late SpriteAnimationComponent _upComponent;

  /// animation in flying up mode
  late SpriteAnimationComponent _idleComponent;

  /// animation in falling mode
  late SpriteAnimationComponent _fallComponent;

  late SpriteAnimationComponent animation2;
  late SpriteAnimationComponent newAnimation;

  /// width and height of the lama in pixel
  late final double _size;
  // final FlappyLamaGame _game;
  /// actual speed of the lama
  double _speedY = 0.0;
  final spriteSize = Vector2(80.0, 90.0);

  double y = 120;

  late double x;
  final FlappyLamaGame2 _game;

  LamaAnimationComponent(this._game, double lamaSize);

  @override
  Future<void> onLoad() async {
    y = 120;
    final spriteSheet = SpriteSheet(
      image: await Flame.images.load('png/lama_animation.png'),
      srcSize: Vector2(24.0, 24.0),
    );

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

    animation2 = _idleComponent;
    // add(animation2);
  }

  void flap() {
    _speedY = _flapSpeed;
  }

  /// This method checks if the [object] hits the obstacle.
  ///
  /// When a hit is triggered the [onCollide] Function gets called.
  /// return:
  ///   true = collides
  ///   false = no collision
/*   bool collides(Rect object) {
    if (object == null) {
      return false;
    }

    // X
    if ((object.left > x - _hitBoxPadding[0] && object.left < x + width - _hitBoxPadding[0]) ||
        (object.right > x - _hitBoxPadding[1] && object.right < x + width - _hitBoxPadding[1])) {
      // Y
      if ((object.top > y - _hitBoxPadding[2] && object.top < y + height - _hitBoxPadding[2]) ||
          (object.bottom > y - _hitBoxPadding[3] && object.bottom < y + height - _hitBoxPadding[3])) {
        // callback
        onCollide?.call();
        return true;
      }
    }

    return false;
  } */

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
    if (y > _game.screenSize.height - _size) {
      // fix the lama
      y = _game.screenSize.height - _size;
      // remove the speed
      _speedY = 0.0;
      // callback
      onHitGround?.call();
      return true;
    }

    return false;
  } */

/*   void update(double t) {
    super.update(t);
    // add(animation);
    var lastY = y;

    // speed
    _speedY += GRAVITY * t;
    // new y
    y += _speedY * t;
    if (true) {
      // last y for animation selection
      var lastY = y;

      // speed
      _speedY += GRAVITY * t;
      // new y
      y += _speedY * t;

      // hits the ground?
/*       if (!isHittingGround()) {
        // hit the top?
        isHittingTop(t); */
    }

    // choose animation
/*     if (lastY > y) {
      animation = _upComponent;
    } else if (lastY < y) {
      animation = _fallComponent;
    } else {
      animation = _idleComponent;
    } */
    add(animation);
    if (testUp == false) {
      animation = _idleComponent;
    }
    if (testUp == true) {
      animation = _upComponent;
    }
  } */

/*   void render(Canvas canvas) {
    add(animation);
    // draw the hitboxframe
    if (_showHitbox) {
      var hitboxPaint = Paint()..color = Color.fromRGBO(255, 0, 0, 0.5);
      canvas.drawRect(toRect(), hitboxPaint);
    }

    super.render(canvas);
  } */

  /// This method returns the rectangle of the lama.
  ///
  /// return
  ///   [Rect] of the hitbox.
  Rect toRect() {
    return Rect.fromLTWH(
        x - _hitBoxPadding[0],
        y - _hitBoxPadding[2],
        _size + _hitBoxPadding[0] + _hitBoxPadding[1],
        _size + _hitBoxPadding[2] + _hitBoxPadding[3]);
  }

/*   void resize(Size size) {
    // start location in the center
    add(animation);
    x = _size;
    y = size.height / 2 - _size;
  } */

  void onTapDown(TapDownInfo info) {
    //  flap();
    y = y - 50;
    newAnimation = SpriteAnimationComponent(
      animation: _upAnimation,
      position: Vector2(150, y),
      size: spriteSize,
    );

    remove(animation2);
    add(newAnimation);

    testUp = true;
  }

  void render(canvas) {
    super.render(canvas);
  }

  void update(double t) {
/*     if (_game.started) {
      // last y for animation selection
      var lastY = y;

      // speed
      _speedY += GRAVITY * t;
      // new y
      y += _speedY * t;
      animation.position.y = y;

      // hits the ground?
/*       if (!isHittingGround()) {
        // hit the top?
        isHittingTop(t);
      } */

      // choose animation
      if (lastY > y) {
        animation = _upComponent;
      } else if (lastY < y) {
        animation = _fallComponent;
      } else {
        animation = _idleComponent;
      }
    } */

    super.update(t);

    // add(animation);
  }
}
