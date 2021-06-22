import 'dart:ui';

import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';

class Monkey extends AnimationComponent {
  // SETTINGS
  // --------
  /// time which is needed to move
  final stepTime = 0.2;
  /// offset (x, y) of the monkey to the center of the screen relative to its size (value * _size)
  final relOffsetCenter = [0.3, 0.0];
  // --------
  // SETTINGS

  /// width and height of the lama in pixel
  final double _size;
  /// animation of idling left
  Animation _idleLeft;
  /// animation of idling right
  Animation _idleRight;
  /// animation of climbing left
  Animation _climbLeft;
  /// animation of climbing right
  Animation _climbRight;
  /// animation of change left
  Animation _switchLeft;
  /// animation of change right
  Animation _switchRight;
  /// is the monkey on the left side of the screen
  bool _isLeft = true;
  /// is the monkey switching the sides
  bool _switching = false;
  /// time left for the switching
  double _switchTimeLeft = 0;
  /// is the monkey moving (switching or climbing)
  bool _moving = false;

  /// Initialize the class with the given [_size] and [_game].
  Monkey(this._size) : super.empty() {
    // size
    height = _size;
    width = _size;

    // loads the spriteSheet from assets
    final spriteSheet = SpriteSheet(
      imageName: 'png/monkey_animation.png',
      textureWidth: 48,
      textureHeight: 48,
      columns: 11,
      rows: 1,
    );

    // loads the spriteSheet from assets
    final spriteSheetMirror = SpriteSheet(
      imageName: 'png/monkey_animation_mirror.png',
      textureWidth: 48,
      textureHeight: 48,
      columns: 11,
      rows: 1,
    );

    // idle
    _idleLeft = spriteSheet.createAnimation(0, loop: true, from: 0, to: 2, stepTime: stepTime / 4);
    _idleRight = spriteSheetMirror.createAnimation(0, loop: true, from: 0, to: 2, stepTime: stepTime / 4);

    // climb
    _climbLeft = spriteSheet.createAnimation(0, loop: false, from: 3, to: 7, stepTime: stepTime / 4);
    _climbRight = spriteSheetMirror.createAnimation(0, loop: false, from: 3, to: 7, stepTime: stepTime / 4);

    // change
    _switchLeft = spriteSheet.createAnimation(0, loop: false, from: 8, to: 11, stepTime: stepTime / 4);
    _switchRight = spriteSheetMirror.createAnimation(0, loop: false, from: 8, to: 11, stepTime: stepTime / 4);

    animation = _idleLeft;
  }

  void move(ClimbSide side) {
    switch (side) {
      case ClimbSide.Left:
        _isLeft ? climbUp() : switchSides();
        break;
      case ClimbSide.Right:
        _isLeft ? switchSides() : climbUp();
        break;
    }
  }

  void climbUp() {
    if (_moving) {
      return;
    }

    _moving = true;

    animation = _isLeft ? _climbLeft : _climbRight
      ..reset()
      ..onCompleteAnimation = () => _moving = false;
  }

  void switchSides() {
    if (_moving) {
      return;
    }

    _moving = true;
    _switching = true;
    _switchTimeLeft = stepTime;

    animation = _isLeft ? _switchLeft : _switchRight
      ..reset();
  }

  @override
  void update(double t) {
    // monkey is switching the sides
    if (_moving && _switching) {
      if (_switchTimeLeft > 0) {
        // calculate the width the monkey moves on the x coordinate in t
        var stepWidth = (_size + 2 * relOffsetCenter[0] * _size) * ((t < _switchTimeLeft ? t : _switchTimeLeft) / stepTime);
        // decrease or increase the x coordinate depending on the direction
        x += (_isLeft) ? stepWidth : -stepWidth;
        // decrease the switchTimeLeft
        _switchTimeLeft -= t;
      }
      else {
        // reset moving flags
        _switching = false;
        _moving = false;
        _isLeft = !_isLeft;
        animation = _isLeft ? _idleLeft : _idleRight;
      }
    }

    super.update(t);
  }

  void resize(Size size) {
    // start location in the center
    x = size.width / 2 - _size - relOffsetCenter[0] * _size;
    y = size.height / 2 - _size / 2 - relOffsetCenter[1] * _size;
  }
}

enum ClimbSide {
  Left,
  Right
}