import 'dart:collection';
import 'dart:ui';
import 'dart:developer' as developer;

import 'package:lama_app/snake/components/snakeSpriteComponent.dart';
import 'package:lama_app/snake/models/position.dart';
import 'package:lama_app/snake/snakeGame.dart';

import 'apple.dart';

/// This class represents the snake and wraps its [SnakeSpriteComponent]s.
class SnakeComponent {
  // SETTINGS
  /// for development
  final bool log = true;
  // --------
  final double _maxVelocity = 15;
  // --------
  // SETTINGS

  final SnakeGame game;
  /// [Queue]of all [SnakeSpriteComponent]s to wrap them all
  Queue<SnakeSpriteComponent> snakeParts = Queue();
  /// actual velocity of the snake
  double velocity = 3;
  /// callback when the snake bites itself
  Function callbackBiteItSelf;
  /// callback when the snake hits the border
  Function callbackCollideWithBorder;
  /// callback when the snake hits the border
  Function(Apple) callbackEatsApple;
  /// counter to check when the next movement will take place
  double _deltaCounter = 0;
  /// actual direction
  SnakeDirection _actualDirection = SnakeDirection.North;
  /// last direction after the last movement
  SnakeDirection _lastDirection = SnakeDirection.North;

  /// This class needs following parameters for initialisation:
  /// [game] = [SnakeGame] where are fields which need this class to proceed
  /// [startPos] = [Position] of the span location
  /// [velocity] = initial speed of the snake
  SnakeComponent(this.game, Position startPos, this.velocity) {
    // add tail
    snakeParts.addFirst(SnakeSpriteComponent(
        SnakePart.Tail,
        this.game.tileSize,
        SnakeDirection.North)
      ..fieldX = (startPos.x)
      ..fieldY = (startPos.y + this.game.fieldOffsetY + 1));
    // add head
    snakeParts.addFirst(SnakeSpriteComponent(
        SnakePart.Head,
        this.game.tileSize,
        SnakeDirection.North)
      ..fieldX = (startPos.x)
      ..fieldY = (startPos.y + this.game.fieldOffsetY));
  }

  /// This is the setter of [_actualDirection]
  /// [dir] could be: 1 = north, 2 = west, 3 = south, 4 = east, else = not valid / ignored
  /// You cant move in the opposite direction so this will gets ignored.
  set direction(SnakeDirection dir) {
    if (dir != _lastDirection) {
      // check the opposite direction
      if (!(_lastDirection == SnakeDirection.North && dir == SnakeDirection.South) &&
          !(_lastDirection == SnakeDirection.South && dir == SnakeDirection.North) &&
          !(_lastDirection == SnakeDirection.West && dir == SnakeDirection.East) &&
          !(_lastDirection == SnakeDirection.East && dir == SnakeDirection.West)) {
        _actualDirection = dir;
      }
    }
  }

  /// This method moves the snake by the given direction for 1 tile.
  /// [dir] 1 = north, 2 = west, 3 = south everything else = east
  void moveSnake(SnakeDirection dir, List<Apple> apples) {
    var newPart = getNextHead(dir);

    // snake would move out of the game field
    if (newPart == null) {
      if (log) {
        developer.log("[Snake][moveSnake] collide with the border");
      }

      // run collision callback
      if (callbackCollideWithBorder != null) {
        callbackCollideWithBorder();
      }
    }
    // snake would collide with itself
    else if (collideWithSnake(Position(newPart.fieldX, newPart.fieldY))) {
      if (log) {
        developer.log("[Snake][moveSnake] biteItSelf");
      }

      // run bite callback
      if (callbackBiteItSelf != null) {
        callbackBiteItSelf();
      }
    }
    else {
      // when the snake changes direction
      // a Snake corner is necessary and needs a different location calculation for the rotation
      if (_lastDirection != _actualDirection) {
        snakeParts.first.part = SnakePart.BodyCorner;

        if ((_lastDirection == SnakeDirection.North && _actualDirection == SnakeDirection.West) ||
            (_lastDirection == SnakeDirection.East && _actualDirection == SnakeDirection.South)) {
          snakeParts.first.direction = SnakeDirection.West;
        }
        else if ((_lastDirection == SnakeDirection.South && _actualDirection == SnakeDirection.East) ||
            (_lastDirection == SnakeDirection.West && _actualDirection == SnakeDirection.North)) {
          snakeParts.first.direction = SnakeDirection.East;
        }
        else if ((_lastDirection == SnakeDirection.South && _actualDirection == SnakeDirection.West) ||
            (_lastDirection == SnakeDirection.East && _actualDirection == SnakeDirection.North)) {
          snakeParts.first.direction = SnakeDirection.North;
        }
        else if ((_lastDirection == SnakeDirection.North && _actualDirection == SnakeDirection.East) ||
            (_lastDirection == SnakeDirection.West && _actualDirection == SnakeDirection.South)) {
          snakeParts.first.direction = SnakeDirection.South;
        }
      }
      else {
        // switch the old head to a body part
        snakeParts.first.part = SnakePart.Body;
      }

      if (log) {
        developer.log("[SnakeComponent][moveSnake] x=${newPart.fieldX},y=${newPart.fieldY}");
      }

      snakeParts.addFirst(newPart);
      _lastDirection = _actualDirection;
      
      growOnHittingApple(apples);
    }
  }

  /// This method checks if the snake head hits an [apple] and will handle the possible growth.
  ///
  /// [apples] = [List] of [Apple]s to check the collision
  void growOnHittingApple(List<Apple> apples) {
    if (apples != null) {
      for (Apple apple in apples) {
        if (collideWithHead(apple.position)) {
          if (callbackEatsApple != null) {
            callbackEatsApple(apple);
          }
          if (log) {
            developer.log("[SnakeComponent][eatApples] eat an apple");
          }

          return;
        }
      }
    }

    // remove the old tail
    snakeParts.removeLast();
    // remove the part where the new tail will come
    var tmp = snakeParts.removeLast()
      ..part = SnakePart.Tail;
    // get Direction of the new Tail part
    // - necessary because the corners have a different direction than the others
    tmp.direction =  getDirection(
        Position(tmp.fieldX, tmp.fieldY),
        Position(snakeParts.last.fieldX, snakeParts.last.fieldY)
    );
    // add the new tail at the end
    snakeParts.addLast(tmp);
  }

  /// This method checks if the head is on the given [position]
  bool collideWithHead(Position position) {
    return position != null &&
        snakeParts.first.fieldX == position.x &&
        snakeParts.first.fieldY == position.y;
  }

  /// This method checks if there is a part of the snake on the given [position]
  bool collideWithSnake(Position position) {
    return position != null &&
        snakeParts.where((it) => it.fieldX == position.x && it.fieldY == position.y).isNotEmpty;
  }

  /// This method needs a [dir] for the next [SnakeComponent].
  /// return:
  /// null = next location is outside the game field or [dir] is null
  /// else = next Head Component with the new Head Position
  SnakeSpriteComponent getNextHead(SnakeDirection dir) {
    if (dir == null) {
      return null;
    }

    // get the old head
    var headPart = snakeParts.first;

    switch(dir) {
      case SnakeDirection.South : {
        // collide with the border
        if (headPart.fieldY >= (this.game.maxFieldY + this.game.fieldOffsetY)) {
          return null;
        }

        return SnakeSpriteComponent(
            SnakePart.Head,
            this.game.tileSize,
            dir)
          ..fieldX = headPart.fieldX
          ..fieldY = headPart.fieldY + 1;
      }
      case SnakeDirection.West : {
        // collide with the border
        if (headPart.fieldX <= 1) {
          return null;
        }

        return SnakeSpriteComponent(
            SnakePart.Head,
            this.game.tileSize,
            dir)
          ..fieldX = headPart.fieldX - 1
          ..fieldY = headPart.fieldY;
      }
      case SnakeDirection.North : {
        // collide with the border
        if (headPart.fieldY <= (this.game.fieldOffsetY + 1)) {
          return null;
        }

        return SnakeSpriteComponent(
            SnakePart.Head,
            this.game.tileSize,
            dir)
          ..fieldX = headPart.fieldX
          ..fieldY = headPart.fieldY - 1;
      }
      case SnakeDirection.East : {
        // collide with the border
        if (headPart.fieldX >= this.game.maxFieldX) {
          return null;
        }

        return SnakeSpriteComponent(
            SnakePart.Head,
            this.game.tileSize,
            dir)
          ..fieldX = headPart.fieldX + 1
          ..fieldY = headPart.fieldY;
      }
    }

    return null;
  }

  /// This method decides which [SnakeDireciton] is necessary to reach the next [Position].
  /// return:
  /// null = [to] or [from] are null or [from] has the same coordinates as [to]
  /// else = next [SnakeDirection]
  SnakeDirection getDirection(Position from, Position to) {
    if (to == null || from == null) {
      return null;
    }

    if (to.x > from.x) {
      return SnakeDirection.East;
    }
    if (to.x < from.x) {
      return SnakeDirection.West;
    }
    if (to.y > from.y) {
      return SnakeDirection.South;
    }
    if (to.y < from.y) {
      return SnakeDirection.North;
    }

    return null;
  }

  void render(Canvas c) {
    // render each part of the snake
    for (SnakeSpriteComponent tmpSnake in snakeParts) {
      tmpSnake.render(c);
    }
  }

  void update(double t, List<Apple> apples) {
    // measures the time which has past since the last reset
    _deltaCounter += t;

    // moves the snake depending on its velocity
    if (_deltaCounter / (1 / (velocity > _maxVelocity ? _maxVelocity : velocity)) > 1.0) {
      // moves the snake
      moveSnake(_actualDirection, apples);

      // resets the deltaCounter
      _deltaCounter = 0;
    }
  }
}

/// This enum represents the compass directions
enum SnakeDirection {
  North,
  West,
  South,
  East
}