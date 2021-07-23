import 'dart:ui';

import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';

/// This class is [AnimationComponent] to display a monkey with all its properties.
class Monkey extends AnimationComponent {
  // SETTINGS
  // --------
  /// time which is needed to move
  final stepTime;
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
  double _moveTimeLeft = 0;
  /// is the monkey moving (switching or climbing)
  bool _moving = false;
  /// Function which gets called when the movement finished
  Function onMovementFinished;

  get isLeft {
    return _isLeft;
  }

  get isMoving {
    return _moving;
  }

  /// Initialize the class with the given [_size] and [_game].
  Monkey(this._size, this.stepTime) : super.empty() {
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
    _idleLeft = spriteSheet.createAnimation(0, loop: true, from: 0, to: 3, stepTime: stepTime);
    _idleRight = spriteSheetMirror.createAnimation(0, loop: true, from: 0, to: 3, stepTime: stepTime);

    // climb
    _climbLeft = spriteSheet.createAnimation(0, loop: false, from: 3, to: 7, stepTime: stepTime / 4);
    _climbRight = spriteSheetMirror.createAnimation(0, loop: false, from: 3, to: 7, stepTime: stepTime / 4);

    // change
    _switchLeft = spriteSheet.createAnimation(0, loop: false, from: 8, to: 11, stepTime: stepTime / 4);
    _switchRight = spriteSheetMirror.createAnimation(0, loop: false, from: 8, to: 11, stepTime: stepTime / 4);

    animation = _idleLeft;
  }

  /// This method will activate the matching move animation to its [side] and its constraints.
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

  /// This method will activate the climb up animation one time to its corresponding side and set its constraints.
  ///
  /// sideeffects:
  ///   [_moving] = true
  ///   [_animation] = climb animation
  void climbUp() {
    if (_moving) {
      return;
    }

    _moving = true;
    _moveTimeLeft = stepTime;

    animation = _isLeft ? _climbLeft : _climbRight
      ..reset();
  }


  /// This method will activate the switch animation one time to its corresponding side and set its constraints.
  ///
  /// sideeffects:
  ///   [_moving] = true
  ///   [_switching] = true
  ///   [_moveTimeLeft] = [stepTime]
  ///   [_animation] = switch animation
  void switchSides() {
    if (_moving) {
      return;
    }

    _moving = true;
    _switching = true;
    _moveTimeLeft = stepTime;

    animation = _isLeft ? _switchLeft : _switchRight
      ..reset();
  }

  @override
  void update(double t) {
    // monkey is switching the sides
    if (_moving) {
      if (_moveTimeLeft > 0) {
        if (_switching) {
          // calculate the width the monkey moves on the x coordinate in t
          var stepWidth = (_size + 2 * relOffsetCenter[0] * _size) * ((t < _moveTimeLeft ? t : _moveTimeLeft) / stepTime);
          // decrease or increase the x coordinate depending on the direction
          x += (_isLeft) ? stepWidth : -stepWidth;
        }
        // decrease the switchTimeLeft
        _moveTimeLeft -= t;
      }
      else {
        if (_switching) {
          _switching = false;
          _isLeft = !_isLeft;
        }

        // reset moving flags
        _moving = false;
        animation = _isLeft ? _idleLeft : _idleRight;

        onMovementFinished?.call();
      }
    }

    super.update(t);
  }

  void resize(Size size) {
    // start location in the center with the offset
    x = size.width / 2 - _size - relOffsetCenter[0] * _size;
    y = size.height / 1.4 - _size / 2 - relOffsetCenter[1] * _size;
  }
}

enum ClimbSide {
  Left,
  Right
}