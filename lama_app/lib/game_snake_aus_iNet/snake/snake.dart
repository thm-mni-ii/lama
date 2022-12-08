import 'dart:collection';

import 'package:flame/components.dart';
import 'package:lama_app/game_snake_aus_iNet/snake/snake_body_part.dart';

import '../component/cell.dart';

enum Direction { up, right, down, left }

class Snake extends SpriteComponent {
  final LinkedList<SnakeBodyPart> snakeBody = LinkedList();

  Direction direction = Direction.right;
  Cell head = Cell.zero;
  Cell tail = Cell.zero;

  Direction wichDir() {
    return direction;
  }

  void move(Cell nextCell) {
    _removeLast();
    head = nextCell;
    _addFirst(head, 0);
    setPrevHeadToBody();
    setNextTail();
  }

  void grow(Cell nextCell) {
    head = nextCell;
    _addFirst(head, 0);
    setPrevHeadToBody();
    // setNextTail();
  }

  bool checkCrash(Cell nextCell) {
    for (var part in snakeBody) {
      if (part.cell == nextCell) {
        return true;
      }
    }

    return false;
  }

  void setHead(Cell cell) {
    head = cell;
  }

  void setTail(Cell cell) {
    tail = cell;
  }

  bool isHorizontal() {
    return direction == Direction.left || direction == Direction.right;
  }

  Vector2 displacementToHead(Vector2 reference) {
    return reference - head.location;
  }

  void addCell(Cell cell) {
    //hier wird nur irgend ein Teil eingefügt, -> unterscheidung zwischen head und body muss erfolgen
    if (cell == head) {
      _add(SnakeBodyPart.fromCell(cell, 0));
    } else {
      _add(SnakeBodyPart.fromCell(cell, 1));
    }
  }

  void _add(SnakeBodyPart part) {
    snakeBody.add(part);
  }

  void _addFirst(Cell cell, int ishead) {
    //zu diesem Zeitpunkt ist die übergebene cell immer ein Head an dieser Stelle, nachfolgenden UNterscheidung bringt noch nichts
    if (ishead == 0) {
      snakeBody.addFirst(SnakeBodyPart.fromCell(cell, 0));
      if (direction == Direction.left) {
        head.setDirectionSnakeHead(3);
        head.cellDirection = CellDirection.left;
        snakeBody.first.cell.cellDirection = CellDirection.left;
        snakeBody.first.next!.cell.cellDirection = CellDirection.left;
      }
      if (direction == Direction.right) {
        head.setDirectionSnakeHead(4);
        head.cellDirection = CellDirection.right;
        snakeBody.first.cell.cellDirection = CellDirection.right;
        snakeBody.first.next!.cell.cellDirection = CellDirection.right;
      }
      if (direction == Direction.up) {
        head.setDirectionSnakeHead(2);
        head.cellDirection = CellDirection.up;
        snakeBody.first.cell.cellDirection = CellDirection.up;
        snakeBody.first.next!.cell.cellDirection = CellDirection.up;
      }
      if (direction == Direction.down) {
        head.setDirectionSnakeHead(1);
        head.cellDirection = CellDirection.down;
        snakeBody.first.cell.cellDirection = CellDirection.down;
        snakeBody.first.next!.cell.cellDirection = CellDirection.down;
      }
    }
  }

  void _removeLast() {
    snakeBody.last.cell.cellType = CellType.empty;
    snakeBody.remove(snakeBody.last);
  }

  void setPrevHeadToBody() {
    snakeBody.first.next!.cell.cellType = CellType.snakeBody;
    snakeBody.first.next!.next!.cell.cellType = CellType.snakeBody;
  }

  void setNextTail() {
    tail = snakeBody.last.cell;
    snakeBody.last.cell.cellType = CellType.snakeTail;

/*     if (direction == Direction.left) {
      tail.setDirectionSnakeTail(3);
    }
    if (direction == Direction.right) {
      tail.setDirectionSnakeTail(4);
    }
    if (direction == Direction.up) {
      tail.setDirectionSnakeTail(2);
    }
    if (direction == Direction.down) {
      tail.setDirectionSnakeTail(1);
    } */
  }
}
