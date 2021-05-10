import 'dart:collection';
import 'dart:math';
import 'dart:ui';
import 'dart:developer' as developer;

import 'package:lama_app/snake/models/position.dart';
import 'package:lama_app/snake/snake_game.dart';

class SnakeComponent {
  final bool debugMovement = true;
  final bool log = true;

  Random rnd = Random();
  Queue<Position> snakeParts = Queue();
  double velocity = 5;
  /// callback when the snake bites itself
  Function callbackBiteItSelf;
  /// callback when the snake hits the border
  Function callbackCollideWithBorder;

  final SnakeGame game;

  double _deltaCounter = 0;
  int _direction = 1;

  SnakeComponent(Position startPos, this.game) {
    snakeParts.add(Position(startPos.x, startPos.y + this.game.fieldOffsetY));
  }

  /// This is the setter of [_direction]
  /// [dir] 1 = north, 2 = west, 3 = south, 4 = east, else = not valid / ignored
  set direction(int dir) {
    if (dir != _direction && dir <= 5 && dir > 0) {
      if (!(_direction.isOdd && dir.isOdd || _direction.isEven && dir.isEven)) {
        _direction = dir;
      }
    }
  }

  /// This method moves the snake by the given direction for 1 tile.
  /// [dir] 1 = north, 2 = west, 3 = south everything else = east
  void moveSnake(int dir, [bool grow = false]) {
    Position headPos = snakeParts.last;

    switch(dir) {
      case 3 : {
        if (headPos.y >= this.game.maxFieldY + this.game.fieldOffsetY) {
          headPos = Position(headPos.x, this.game.fieldOffsetY + 1);
          callbackCollideWithBorder();
        }
        else {
          headPos = Position(headPos.x, headPos.y + 1);
        }

        break;
      }
      case 2 : {
        if (headPos.x >= this.game.maxFieldX) {
          headPos = Position(1, headPos.y);
          callbackCollideWithBorder();
        }
        else {
          headPos = Position(headPos.x + 1, headPos.y);
        }

        break;
      }
      case 1 : {
        if (headPos.y <= this.game.fieldOffsetY + 1) {
          headPos = Position(headPos.x, this.game.maxFieldY + this.game.fieldOffsetY);
          callbackCollideWithBorder();
        }
        else {
          headPos = Position(headPos.x, headPos.y - 1);
        }

        break;
      }
      default : {
        if (headPos.x <= 1) {
          headPos = Position(this.game.maxFieldX, headPos.y);
          callbackCollideWithBorder();
        }
        else {
          headPos = Position(headPos.x - 1, headPos.y);
        }

        break;
      }
    }

    if (collideWithSnake(headPos)) {
      if (callbackBiteItSelf != null) {
        callbackBiteItSelf();
      }

      if (log) {
        developer.log("[Snake][moveSnake] biteItSelf = true");
      }
    } else {
      // only removes the tail when no growth
      if (!grow) {
        snakeParts.removeFirst();
      } else if (log) {
        developer.log("[Snake][moveSnake] growth");
      }

      // adds the new head
      snakeParts.add(headPos);
    }
  }

  /// This method checks if the head is on the given [position]
  bool collideWithHead(Position position) {
    return position != null &&
        snakeParts.last.x == position.x &&
        snakeParts.last.y == position.y;
  }

  /// This method checks if there is an snakepart on the given [position]
  bool collideWithSnake(Position position) {
    return position != null &&
        snakeParts.where((it) => it.x == position.x && it.y == position.y).isNotEmpty;
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
      bgPaint.color = Color(tmpSnake == snakeParts.last ? 0xFF208421 : 0xFF200021);

      c.drawArc(bgRect, 0, 10, true, bgPaint);
    }
  }

  void update(double t) {
    // measures the time which has past
    _deltaCounter += t;

    // moves the snake depending on its velocity
    if (_deltaCounter / (1 / velocity) > 1.0) {
      // debug_movement = snake moves towards an random direction
      if (debugMovement) {
        direction = rnd.nextInt(5);
      }

      // debug_movement = snake growths with 10% chance
      moveSnake(_direction, debugMovement ? rnd.nextInt(100) > 90 : false);

      // resets the deltaCounter
      _deltaCounter = 0;
    }
  }
}