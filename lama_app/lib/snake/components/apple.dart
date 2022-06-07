import 'dart:math';
import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:lama_app/snake/snakeGame.dart';
import 'package:lama_app/snake/models/position.dart';

/// This class will render the apple and consists of all necessary properties.
class Apple {
  final SnakeGame _game;
  /// the current position of the apple on the game field
  Position position;
  /// the [Rect] of the apple
  Rect _appleRect;
  Random _rnd = Random();
  /// the relative size of the apple related to the games tilesize
  double _relativeToTile = 0.85;
  /// the [Sprite] of the Apple
  Sprite _imageSprite;

  /// The constructor needs the owning game as well as the position the Apple
  /// shouldnt located on.
  Apple(this._game, [List<Position> excludePositions]) {
    setRandomPosition(excludePositions);

    _imageSprite = Sprite('png/apple.png');
  }

  /// This method sets a new random [Position] of the Apple.
  /// [excludePositions] = this Positions will get ignored when finding a new one
  void setRandomPosition([List<Position> excludePositions]) {
    // new random Position
    var newPosition = Position(_rnd.nextInt(this._game.maxFieldX) + 1, _rnd.nextInt(this._game.maxFieldY) + this._game.fieldOffsetY + 1);

    // exclude a list of Positions
    if (excludePositions != null) {
      while (excludePositions.any((pos) => pos.x == newPosition.x && pos.y == newPosition.y)) {
        newPosition = Position(_rnd.nextInt(this._game.maxFieldX) + 1, _rnd.nextInt(this._game.maxFieldY) + this._game.fieldOffsetY + 1);
      }
    }

    position = newPosition;

    // calculate the new rectangle
    _appleRect = Rect.fromLTWH(
        (newPosition.x - 1) * this._game.tileSize,
        (newPosition.y - 1) * this._game.tileSize,
        this._game.tileSize,
        this._game.tileSize);
  }

  void render(Canvas c) {
    //c.drawArc(_appleRect.deflate(this.game.tileSize * (1 - _relativeToTile)), 0, 10, true, _applePaint);

    _imageSprite.renderRect(c, _appleRect.deflate(this._game.tileSize * (1 - _relativeToTile)));
  }

  void update(double timeDelta) {}
}