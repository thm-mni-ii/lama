import 'dart:math';
import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';

class SnakeSpriteComponent extends SpriteComponent {
  int direction = 0;
  int _fieldX = 0;
  int _fieldY = 0;
  double _tilesize;
  SnakePart _part;

  SnakeSpriteComponent(SnakePart part, this._tilesize, int direction) {
    width = _tilesize;
    height = _tilesize;
    anchor = Anchor.center;

    this.part = part;
    setDirection(direction);
  }

  set part(SnakePart part) {
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

    this._part = part;
  }

  set fieldX(int x) {
    _fieldX = x;
    this.x = (x - 1) * this._tilesize;
  }

  get fieldX => _fieldX;

  set fieldY(int y) {
    _fieldY = y;
    this.y = (y - 1) * this._tilesize;
  }

  get fieldY => _fieldY;

  void setDirection(int dir) {
    switch (dir) {
      case 1:
        // 180
        angle = pi;
        break;
      case 2:
        // 90
        angle =  pi / 2;
        break;
      case 3:
        // 0
        angle = 0;
        break;
      case 4:
        // 270
        angle = - pi / 2;
        break;
      default:
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