import 'dart:math';
import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:lama_app/snake/components/snake.dart';

class SnakeSpriteComponent extends SpriteComponent {
  SnakeDirection _direction = SnakeDirection.North;
  int _fieldX = 0;
  int _fieldY = 0;
  double _tileSize;
  SnakePart _part;

  SnakeSpriteComponent(SnakePart part, this._tileSize, SnakeDirection direction) {
    width = _tileSize;
    height = _tileSize;
    anchor = Anchor.center;

    this.part = part;
    this.direction = direction;
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

  get part => _part;

  /// This setter will also calculate the [x] Value of the class with the [tilesize].
  set fieldX(int x) {
    _fieldX = x;
    this.x = (x - 1) * this._tileSize;
  }

  get fieldX => _fieldX;

  /// This setter will also calculate the [y] Value of the class with the [tilesize].
  set fieldY(int y) {
    _fieldY = y;
    this.y = (y - 1) * this._tileSize;
  }

  get fieldY => _fieldY;

  /// This setter also determines the rotation angle of the sprite.
  set direction(SnakeDirection dir) {
    switch (dir) {
      case SnakeDirection.North:
        // 180
        angle = pi;
        break;
      case SnakeDirection.West:
        // 90
        angle =  pi / 2;
        break;
      case SnakeDirection.South:
        // 0
        angle = 0;
        break;
      case SnakeDirection.East:
        // 270
        angle = - pi / 2;
        break;
    }

    _direction = dir;
  }

  SnakeDirection get direction => _direction;

  void render(Canvas canvas) {
    // save the actual canvas
    canvas.save();
    canvas.translate(width * 0.5, height * 0.5);
    super.render(canvas);
    // restores the old canvas
    canvas.restore();
  }
}

enum SnakePart {
  Head,
  Tail,
  Body,
  BodyCorner
}