import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

/// This class is [SpriteComponent] with a tree [Sprite].
class TreeSprite extends SpriteComponent with HasGameRef {
  /// flag for the alter sprite
  bool alterSprite = false;
  late SpriteComponent tmp;
  late SpriteComponent tmp2;
  late double _height;
  late double _width;
  late double _x;
  late double _y;

  /// This constructor needs the [width], [height], [x], [y] and
  /// [alterSprite] which indicates if the alternating sprite is needed.
  TreeSprite(double width, double height, double x, double y,
      [this.alterSprite = true]) {
    _width = width;
    _height = height + 0.5;
    _x = x;
    _y = y;
  }

  @override
  Future<void> onLoad() async {
    alterSprite
        ? sprite = await gameRef.loadSprite('png/tree7th.png')
        : sprite = await gameRef.loadSprite('png/tree7th2.png');
    tmp = SpriteComponent()
      ..sprite = await gameRef.loadSprite('png/tree7th.png')
      ..height = _height + 0.5
      ..width = _width
      ..x = _x
      ..y = _y;
    // ..anchor = Anchor.topLeft;

    tmp2 = SpriteComponent()
      ..sprite = await gameRef.loadSprite('png/tree7th2.png')
      ..height = _height + 0.5
      ..width = _width
      ..x = _x
      ..y = _y;
    // ..anchor = Anchor.topLeft;
    alterSprite ? add(tmp) : add(tmp2);
    //add(tmp);
  }
}
