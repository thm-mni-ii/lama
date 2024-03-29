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

class SnakeBodyy extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<SnakeGame> {
  final Vector2 velocity;

  late SpriteAnimation _upAnimation;
  late SpriteAnimation _leftOrRightAnimation;
  late SpriteAnimation _downOrUpAnimation;
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

  // final SnakeGame _game;

  /// actual speed of the lama
  double _speedY = 0.0;

  /// gravity of the lama = falling speed
  static const double GRAVITY = 1000;

  /// speed increase/decrease when [flap] gets called = flap height
  final double _flapSpeed = -320;

  /// width and height of the lama in pixel
  final double _size;

  bool boolIsHittingTop = false;

  late SpriteAnimation _bottomToRightCurveAnimation;

  late SpriteAnimation _bottomToLeftCurveAnimation;

  SnakeBodyy(
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
    height = 34;
    width = 34;

    animation = await gameRef.loadSpriteAnimation(
      'png/snake_body.png',
      SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: 0.2,
        textureSize: Vector2.all(30),
      ),
    );
////////////////////////////////////////////////////////////
    ///
    ///

    final spriteSheetdownOrUp = SpriteSheet(
      image: await Flame.images.load('png/snake_body.png'),
      srcSize: Vector2(30.0, 30.0),
    );

    final spriteSheetleftOrRight = SpriteSheet(
      image: await Flame.images.load('png/snake_body_leftOrRight.png'),
      srcSize: Vector2(30.0, 30.0),
    );

    final spriteSheetBottomToRightCurve = SpriteSheet(
      image: await Flame.images.load('png/snake_body_curve_BottomToRight.png'),
      srcSize: Vector2(30.0, 30.0),
    );

    final spriteSheetBottomToLeftCurve = SpriteSheet(
      image: await Flame.images.load('png/snake_body_curve_bottomToLeft.png'),
      srcSize: Vector2(30.0, 30.0),
    );

    final spriteSize = Vector2(60.0, 60.0);
    // idle / hover animation
    _currentAnimation = spriteSheetleftOrRight.createAnimation(
        row: 0, from: 0, to: 1, stepTime: 0.1);

    _leftOrRightAnimation = spriteSheetleftOrRight.createAnimation(
        row: 0, from: 0, to: 1, stepTime: 0.1);

    _bottomToRightCurveAnimation = spriteSheetBottomToRightCurve
        .createAnimation(row: 0, from: 0, to: 1, stepTime: 0.1);

    _bottomToLeftCurveAnimation = spriteSheetBottomToLeftCurve.createAnimation(
        row: 0, from: 0, to: 1, stepTime: 0.1);

    _downOrUpAnimation = spriteSheetdownOrUp.createAnimation(
        row: 0, from: 0, to: 1, stepTime: 0.1);

    // start animation

    ////////////////////////////////////////////////////////////
    ///
    ///
    final hitboxPaint = BasicPalette.green.paint()
      ..style = PaintingStyle.stroke;
    add(PolygonHitbox.relative(
      [
        Vector2(-1.0, 0.0),
        Vector2(-1.0, -1.0),
        Vector2(0.0, -1.0),
        Vector2(0.0, 0.0),
      ],
      parentSize: spriteSize,
    )
/*         ..paint = hitboxPaint
        ..renderShape = true, */
        );
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
    animation = _currentAnimation;
  }

  void setDirectionOfAnimation(int a) {
    switch (a) {
      case 0:
        _currentAnimation = _downOrUpAnimation;
        break;
      case 1:
        setBodyToBottomRightCruve();
        break;
      case 2:
        setBodyToBottomLeftCruve();
        break;
      case 3:
        _currentAnimation = _leftOrRightAnimation;
        break;
      case 4:
        _currentAnimation = _leftOrRightAnimation;
        break;
      default:
    }
  }

  void setBodyToBottomRightCruve() {
    _currentAnimation = _bottomToRightCurveAnimation;
  }

  void setBodyToBottomLeftCruve() {
    _currentAnimation = _bottomToLeftCurveAnimation;
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
