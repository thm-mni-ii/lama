import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';

class ClimberTree extends SpriteComponent {
  /// flag for the alter sprite
  bool alterSprite = false;

  ClimberTree(double width, double height, double x, double y, [this.alterSprite = false]) {
    sprite = alterSprite ? Sprite('png/tree7th.png') : Sprite('png/tree7th2.png');
    this.width = width;
    this.height = height + 0.5;
    this.x = x;
    this.y = y;
  }
}