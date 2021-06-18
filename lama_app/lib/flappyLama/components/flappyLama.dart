import 'dart:ui';

import 'package:lama_app/flappyLama/flappyLamaGame.dart';
import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';

/// This class extends [AnimationComponent] and describes a flying lama.
/// It contains three different animations for idle, up and falling.
class FlappyLama extends AnimationComponent {
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
  // SETTINGS

  /// callback when the lama hits an object in [collides(Rect object)]
  Function onCollide;
  /// callback when the lama hits the ground
  Function onHitGround;
  /// callback when the lama hits the top
  Function onHitTop;

  /// animation in idle mode
  Animation _idle;
  /// animation in flying up mode
  Animation _up;
  /// animation in falling mode
  Animation _fall;
  /// width and height of the lama in pixel
  final double _size;
  final FlappyLamaGame _game;
  /// actual speed of the lama
  double _speedY = 0.0;

  /// Initialize the class with the given [_size] and [_game].
  FlappyLama(this._game, this._size) : super.empty() {
    // size
    height = _size;
    width = _size;

    // loads the spritesheet from assets
    final spriteSheet = SpriteSheet(
      imageName: 'png/lama_animation.png',
      textureWidth: 24,
      textureHeight: 24,
      columns: 12,
      rows: 1,
    );

    // idle / hover animation
    _idle = spriteSheet.createAnimation(0, from: 0, to: 4, stepTime: 0.1);

    // up animation
    _up = spriteSheet.createAnimation(0, from: 5, to: 8, stepTime: 0.1);

    // fall animation
    _fall = spriteSheet.createAnimation(0, from: 9, to: 12, stepTime: 0.1);

    // start animation
    animation = _idle;
  }

  /// This method let the lama fly up with an impuls.
  ///
  /// sideffects:
  ///   [_speedY] = [_flapSpeed]
  void flap() {
    _speedY = _flapSpeed;
  }

  /// This method checks if the [object] hits the obstacle.
  ///
  /// When a hit is triggered the [onCollide] Function gets called.
  /// return:
  ///   true = collides
  ///   false = no collision
  bool collides(Rect object) {
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
  }

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
    if (y <= 0) {
      _speedY = 0.0;
      _speedY += GRAVITY * t;
      y += _speedY * t;

      // callback
      onHitTop?.call();
      return true;
    }

    return false;
  }

  void update(double t) {
    if (_game.started) {
      // last y for animation selection
      var lastY = y;

      // speed
      _speedY += GRAVITY * t;
      // new y
      y += _speedY * t;

      // hits the ground?
      if (!isHittingGround()) {
        // hit the top?
        isHittingTop(t);
      }

      // choose animation
      if (lastY > y) {
        animation = _up;
      } else if (lastY < y) {
        animation = _fall;
      } else {
        animation = _idle;
      }
    }

    super.update(t);
  }

  void render(Canvas canvas) {
    // draw the hitboxframe
    if (_showHitbox) {
      var hitboxPaint = Paint()
          ..color = Color.fromRGBO(255, 0, 0, 0.5);
      canvas.drawRect(toRect(), hitboxPaint);
    }

    super.render(canvas);
  }

  void resize(Size size) {
    // start location in the center
    x = _size;
    y = size.height / 2 - _size;
  }

  void onTapDown() {
    // simulates one flap
    flap();
  }

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
}
