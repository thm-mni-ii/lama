import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';

class SnakeSpriteComponent extends SpriteComponent {
  SnakeSpriteComponent(SnakePart part, double tileSize) {
    width = tileSize;
    height = tileSize;
    anchor = Anchor.center;

    switch (part) {
      case SnakePart.Head:
        sprite = Sprite('png/snake_head.png');
        break;
      case SnakePart.Body:
        sprite = Sprite('png/snake_body.png');
        break;
      case SnakePart.BodyCorner:
        sprite = Sprite('png/snake_body_curve.png');
        break;
      case SnakePart.Tail:
        sprite = Sprite('png/snake_tail.png');
        break;
    }
  }

  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(width * 0.5, height * 0.5);
    super.render(canvas);
    canvas.restore();
  }
}

enum SnakePart {
  Head,
  Tail,
  Body,
  BodyCorner
}