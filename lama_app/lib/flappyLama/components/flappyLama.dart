import 'dart:ui';
import 'package:lama_app/flappyLama/flappyLamaGame.dart';
import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';

/// This class extends [AnimationComponent] and describes a flying lama.
/// It contains three different animations for idle, up and falling.
class FlappyLama extends AnimationComponent {
  Function onCollide;
  Function onHitGround;

  Animation _idle;
  Animation _up;
  Animation _fall;
  double _size;

  final FlappyLamaGame _game;
  bool _isGameStarted = false;
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
  /// return:
  ///   true = collides
  ///   false = no collision
  bool collides(Rect object) {
    if (object == null) {
      return false;
    }

    // X
    if ((object.left > this.x && object.left < this.x + this.width) ||
        (object.right > this.x && object.right < this.x + this.width)) {
      // Y
      if ((object.top > this.y && object.top < this.y + this.height) ||
          (object.bottom > this.y && object.bottom < this.y + this.height)) {
        // callback
        onCollide?.call();
        return true;
      }
    }

    return false;
  }

  void update(double t) {
    if (_isGameStarted == true) {
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
    _isGameStarted = true;
    flap();
  }

  Rect toRect() {
    return Rect.fromLTWH(this.x, this.y, this._size, this._size);
  }

  bool collides(Object object) {
    if (this.y + this.height == object) {
      return true;
    } else {
      return false;
    }
  }
}
