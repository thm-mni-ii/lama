import 'dart:collection';
import 'dart:math';
import 'dart:ui';
import 'dart:developer' as developer;

import 'package:lama_app/snake/models/position.dart';
import 'package:lama_app/snake/snake_game.dart';

import 'apple.dart';

class SnakeComponent {
  final bool debugMovement = false;
  final bool log = true;

  Random rnd = Random();
  Queue<Position> snakeParts = Queue();
  double velocity = 3;
  /// callback when the snake bites itself
  Function callbackBiteItSelf;
  /// callback when the snake hits the border
  Function callbackCollideWithBorder;
  /// callback when the snake hits the border
  Function(Apple) callbackEatsApple;

  final SnakeGame game;

  double _deltaCounter = 0;
  int _direction = 1;
  double _maxVelocity = 15;

  SnakeComponent(this.game, Position startPos, this.velocity) {
    snakeParts.add(Position(startPos.x, startPos.y + this.game.fieldOffsetY));
  }

  /// This is the setter of [_direction]
  /// [dir] could be: 1 = north, 2 = west, 3 = south, 4 = east, else = not valid / ignored
  /// You cant move in the opposite direction so this will gets ignored.
  set direction(int dir) {
    if (dir != _direction && dir <= 5 && dir > 0) {
      if (!(_direction.isOdd && dir.isOdd || _direction.isEven && dir.isEven)) {
        _direction = dir;
      }
    }
  }

  /// This method moves the snake by the given direction for 1 tile.
  /// [dir] 1 = north, 2 = west, 3 = south everything else = east
  void moveSnake(int dir) {
    var newPosition = getNewPosition(dir);

    // no movement in between the field possible
    if (newPosition == null) {
      if (log) {
        developer.log("[Snake][moveSnake] collide with the border");
      }

      if (callbackCollideWithBorder != null) {
        callbackCollideWithBorder();
      }
    }
    else if (collideWithSnake(newPosition)) {
      if (log) {
        developer.log("[Snake][moveSnake] biteItSelf");
      }

      if (callbackBiteItSelf != null) {
        callbackBiteItSelf();
      }
    } else {
      snakeParts.addFirst(newPosition);
    }
  }

  /// This method checks if the head is on the given [position]
  bool collideWithHead(Position position) {
    return position != null &&
        snakeParts.first.x == position.x &&
        snakeParts.first.y == position.y;
  }

  /// This method checks if there is an snakepart on the given [position]
  bool collideWithSnake(Position position) {
    return position != null &&
        snakeParts.where((it) => it.x == position.x && it.y == position.y).isNotEmpty;
  }

  /// This method returns the new Position by the given [dir].
  /// [dir] could be: 1 = north, 2 = west, 3 = south everything else = east
  /// return : hits the border = null, movement within the field = [Position]
  Position getNewPosition(int dir) {
    Position headPos = snakeParts.first;

    switch(dir) {
      case 3 : {
        if (headPos.y >= this.game.maxFieldY + this.game.fieldOffsetY) {
          // headPos = Position(headPos.x, this.game.fieldOffsetY + 1);
          return null;
        }

        return Position(headPos.x, headPos.y + 1);
      }
      case 2 : {
        if (headPos.x <= 1) {
          // headPos = Position(this.game.maxFieldX, headPos.y);
          return null;
        }

        return Position(headPos.x - 1, headPos.y);
      }
      case 1 : {
        if (headPos.y <= this.game.fieldOffsetY + 1) {
          // headPos = Position(headPos.x, this.game.maxFieldY + this.game.fieldOffsetY);
          return null;
        }

        return Position(headPos.x, headPos.y - 1);
      }
      default : {
        if (headPos.x >= this.game.maxFieldX) {
          // headPos = Position(1, headPos.y);
          return null;
        }

        return Position(headPos.x + 1, headPos.y);
      }
    }
  }

  void render(Canvas c) {
    // render each part of the snake
    for (Position tmpSnake in snakeParts) {
      // rectangle for each part
      Rect bgRect = Rect.fromLTWH(
          (tmpSnake.x - 1) * this.game.tileSize,
          (tmpSnake.y - 1) * this.game.tileSize,
          this.game.tileSize,
          this.game.tileSize);

      Paint bgPaint = Paint();
      // color the head different than the tail
      bgPaint.color = Color(tmpSnake == snakeParts.first ? 0xFF208421 : 0xFF200021);

      c.drawArc(bgRect, 0, 10, true, bgPaint);
    }
  }

  void eatApples(List<Apple> apples) {
    if (apples == null) {
      // adds the new head
      snakeParts.removeLast();
      return;
    }

    for (Apple apple in apples) {
      if (collideWithHead(apple.position)) {
        if (callbackEatsApple != null) {
          callbackEatsApple(apple);
        }
        developer.log("[SnakeComponent][eatApples] eat an apple");

        return;
      }
    }

    // adds the new head
    snakeParts.removeLast();
  }

  void update(double t, List<Apple> apples) {
    // measures the time which has past
    _deltaCounter += t;

    // moves the snake depending on its velocity
    if (_deltaCounter / (1 / (velocity > _maxVelocity ? _maxVelocity : velocity)) > 1.0) {
      // debug_movement = snake moves towards an random direction
      if (debugMovement) {
        direction = rnd.nextInt(5);
      }

      // debug_movement = snake growths with 10% chance
      moveSnake(_direction);
      eatApples(apples);

      // resets the deltaCounter
      _deltaCounter = 0;
    }
  }
}