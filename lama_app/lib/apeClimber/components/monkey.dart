import 'dart:ui';

import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';

class Monkey extends AnimationComponent {
  /// width and height of the lama in pixel
  final double _size;
  /// animation in idle mode
  Animation _idle;

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
      columns: 6,
      rows: 1,
    );

    // idle / hover animation
    _idle = spriteSheet.createAnimation(0, from: 2, to: 6, stepTime: 0.1);

    // start animation
    animation = _idle;
  }

  void resize(Size size) {
    // start location in the center
    x = size.width / 2 - _size / 2;
    y = size.height - 4*_size;
  }
}