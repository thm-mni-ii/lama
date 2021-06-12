import 'dart:ui';
import 'package:lama_app/flappyLama/flappyLamaGame.dart';
import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';

/// This class extends [AnimationComponent] and describes a flying lama.
/// It contains three different animations for idle, up and falling.
class FlappyLama extends AnimationComponent {
  /// hitbox padding = [left, right, top, bottom] = negative move inwards / positive move outwards
  final hitBoxPadding = [-2.0, -2.0, -2.0, -2.0];

  /// callback when the lama hits an object in [collides(Rect object)]
  Function onCollide;
  /// callback when the lama hits the ground
  Function onHitGround;

  /// animation in idle mode
  Animation _idle;
  /// animation in flying up mode
  Animation _up;
  /// animation in falling mode
  Animation _fall;
  /// width and height of the lama in pixel
  double _size;

  final FlappyLamaGame _game;

  double _speedY = 0.0;
  static const double GRAVITY = 1000;

  /// Initialize the class with the given [_size].
  FlappyLama(this._game, this._size) : super.empty() {
    // size
    this.height = this._size;
    this.width = this._size;

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
    this.animation = _idle;
  }

  /// This method let the lama fly up with an impuls.
  void flap() {
    this._speedY = -320;
  }

  /// This method let the lama fly steady on the actual height.
  void hover() {}

  /// This method checks if the [object] hits the obstacle.
  /// When a hit is triggered the [onCollide] Function gets called.
  /// return:
  ///   true = collides
  ///   false = no collision
  bool collides(Rect object) {
    if (object == null) {
      return false;
    }

    // X
    if ((object.left > this.x - hitBoxPadding[0] && object.left < this.x + this.width - hitBoxPadding[0]) ||
        (object.right > this.x - hitBoxPadding[1] && object.right < this.x + this.width - hitBoxPadding[1])) {
      // Y
      if ((object.top > this.y - hitBoxPadding[2] && object.top < this.y + this.height - hitBoxPadding[2]) ||
          (object.bottom > this.y - hitBoxPadding[3] && object.bottom < this.y + this.height - hitBoxPadding[3])) {
        // callback
        onCollide?.call();
        return true;
      }
    }

    return false;
  }

  void update(double t) {
    if (this._game.started) {
      // speed
      this._speedY += GRAVITY * t;
      // last y for animation selection
      var lastY = this.y;
      // new y
      this.y += this._speedY * t;

      // fall off
      if (this.y > _game.screenSize.height - this._size) {
        y = _game.screenSize.height - this._size;
        _speedY = 0.0;
        onHitGround?.call();
      }
      // hit top
      else if (this.y <= 0) {
        _speedY = 0.0;
        this._speedY += GRAVITY * t;
        this.y += this._speedY * t;
      }

      // choose animation
      if (lastY > this.y) {
        this.animation = _up;
      } else if (lastY < this.y) {
        this.animation = _fall;
      } else {
        this.animation = _idle;
      }
    }

    super.update(t);
  }

  void resize(Size size) {
    // start location
    this.x = this._size;
    this.y = size.height / 2 - this._size;
  }

  void onTapDown() {
    flap();
  }

  Rect toRect() {
    return Rect.fromLTWH(
        this.x - hitBoxPadding[0],
        this.y - hitBoxPadding[0],
        this._size + 2 * hitBoxPadding[0],
        this._size + 2 * hitBoxPadding[0]);
  }
}
