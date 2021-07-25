import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';

/// This class is [SpriteComponent] with a tree [Sprite].
class TreeSprite extends SpriteComponent {
  /// flag for the alter sprite
  bool alterSprite = false;

  /// This constructor needs the [width], [height], [x], [y] and
  /// [alterSprite] which indicates if the alternating sprite is needed.
  TreeSprite(double width, double height, double x, double y, [this.alterSprite = false]) {
    sprite = alterSprite ? Sprite('png/tree7th.png') : Sprite('png/tree7th2.png');
    this.width = width;
    this.height = height + 0.5;
    this.x = x;
    this.y = y;
  }
}