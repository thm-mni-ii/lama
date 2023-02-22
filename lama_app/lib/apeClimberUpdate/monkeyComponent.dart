import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';

/// This class is [AnimationComponent] to display a monkey with all its properties.
class Monkey extends SpriteAnimationComponent with CollisionCallbacks {
  late ShapeHitbox hitbox;
  // SETTINGS
  // --------
  /// time which is needed to move
  late final stepTime;

  /// offset (x, y) of the monkey to the center of the screen relative to its size (value * _size)
  final relOffsetCenter = [0.3, 0.0];
  // --------
  // SETTINGS
  /// width and height of the lama in pixel
  late final double _size;

  /// animation of idling left
  late SpriteAnimation _idleLeft;

  /// animation of idling right
  late SpriteAnimation _idleRight;

  /// animation of climbing left
  late SpriteAnimation _climbLeft;

  /// animation of climbing right
  late SpriteAnimation _climbRight;

  /// animation of change left
  late SpriteAnimation _switchLeft;

  /// animation of change right
  late SpriteAnimation _switchRight;

  /// is the monkey on the left side of the screen
  bool _isLeft = true;

  /// is the monkey switching the sides
  bool _switching = false;

  /// time left for the switching
  double _moveTimeLeft = 0;

  /// is the monkey moving (switching or climbing)
  bool _moving = false;

  /// Function which gets called when the movement finished
  late Function onMovementFinished;

  get isLeft {
    return _isLeft;
  }

  get isMoving {
    return _moving;
  }

  /// Initialize the class with the given [_size] and [_game].
  Monkey(this._size, this.stepTime) {
    // size
    height = _size;
    width = _size;
  }

  @override
  Future<void> onLoad() async {
    // size
    height = _size;
    width = _size;

    final spriteSheet = SpriteSheet(
      image: await Flame.images.load('png/monkey_animation.png'),
      srcSize: Vector2(48.0, 48.0),
    );

    final spriteSheetMirror = SpriteSheet(
      image: await Flame.images.load('png/monkey_animation_mirror.png'),
      srcSize: Vector2(48.0, 48.0),
    );

    // idle
    _idleLeft = spriteSheet.createAnimation(
        row: 0, loop: true, from: 0, to: 3, stepTime: stepTime);
    _idleRight = spriteSheetMirror.createAnimation(
        row: 0, loop: true, from: 0, to: 3, stepTime: stepTime);

    // climb
    _climbLeft = spriteSheet.createAnimation(
        row: 0, loop: false, from: 3, to: 7, stepTime: stepTime / 4);
    _climbRight = spriteSheetMirror.createAnimation(
        row: 0, loop: false, from: 3, to: 7, stepTime: stepTime / 4);

    // change
    _switchLeft = spriteSheet.createAnimation(
        row: 0, loop: false, from: 8, to: 11, stepTime: stepTime / 4);
    _switchRight = spriteSheetMirror.createAnimation(
        row: 0, loop: false, from: 8, to: 11, stepTime: stepTime / 4);

    animation = _idleLeft;
/* WENN DAS HIONZUGEFÜGT WIRD; ENTSTEHEN  UNGEWOLLTE ABSTÄNDE ZWISCHEN DEN BÄUMEN
    final hitboxPaint = BasicPalette.white.paint()
      ..style = PaintingStyle.stroke;
    add(
      PolygonHitbox.relative(
        [
          Vector2(-1.0, 0.0),
          Vector2(-1.0, -1.0),
          Vector2(0.0, -1.0),
          Vector2(0.0, 0.0),
        ],
        parentSize: size,
      )
        ..paint = hitboxPaint
        ..renderShape = true,
    ); */
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
  void update(double dt) {
    if (isColliding == true) {
      print("COLLIUSION");
    }
    // monkey is switching the sides
    if (_moving) {
      if (_moveTimeLeft > 0) {
        if (_switching) {
          // calculate the width the monkey moves on the x coordinate in t
          var stepWidth = (_size + 2 * relOffsetCenter[0] * _size) *
              ((dt < _moveTimeLeft ? dt : _moveTimeLeft) / stepTime);
          // decrease or increase the x coordinate depending on the direction
          x += (_isLeft) ? stepWidth : -stepWidth;
        }
        // decrease the switchTimeLeft
        _moveTimeLeft -= dt;
      } else {
        if (_switching) {
          _switching = false;
          _isLeft = !_isLeft;
        }

        // reset moving flags
        _moving = false;
        animation = _isLeft ? _idleLeft : _idleRight;

        onMovementFinished.call();
      }
    }

    super.update(dt);
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

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
    // start location in the center with the offset
    x = canvasSize.x / 2 - _size - relOffsetCenter[0] * _size;
    y = canvasSize.y / 1.4 - _size / 2 - relOffsetCenter[1] * _size;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    print("LAMA HIT");
    super.onCollisionStart(intersectionPoints, other);
  }
}

enum ClimbSide { Left, Right }
