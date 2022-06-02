import 'dart:math';
import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:lama_app/snake/components/snake.dart';

/// This class represents a single sprite part of the snake.
class SnakeSpriteComponent extends SpriteComponent {
  /// direction of this component
  SnakeDirection _direction = SnakeDirection.North;
  /// x position on the game field
  int _fieldX = 0;
  /// y position on the game field
  int _fieldY = 0;
  /// tilesize of the game field
  double _tileSize;
  /// part of this component
  SnakePart _part;

  /// The constructor need the type of the [part], [_tileSize] and [direction] to
  /// initialize this component.
  SnakeSpriteComponent(SnakePart part, this._tileSize, SnakeDirection direction) {
    width = _tileSize;
    height = _tileSize;
    anchor = Anchor.center;

    this.part = part;
    this.direction = direction;
  }

  /// Setter of the part to load the correct sprite
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

  /// Getter of the part
  get part => _part;

  /// This setter will also calculate the [x] Value of the class with the [tilesize].
  set fieldX(int x) {
    _fieldX = x;
    this.x = (x - 1) * this._tileSize;
  }

  /// Getter of the x coordinate on the game field
  get fieldX => _fieldX;

  /// This setter will also calculate the [y] Value of the class with the [tilesize].
  set fieldY(int y) {
    _fieldY = y;
    this.y = (y - 1) * this._tileSize;
  }

  /// Getter of the y coordinate on the game field
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

  /// Getter of the direction
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

/// This enum represents the different parts of a snake
enum SnakePart {
  Head,
  Tail,
  Body,
  BodyCorner
}