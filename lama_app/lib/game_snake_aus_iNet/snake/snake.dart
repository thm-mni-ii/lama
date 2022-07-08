import 'dart:collection';

import 'package:flame/components.dart';
import 'package:lama_app/game_snake_aus_iNet/snake/snake_body_part.dart';

import '../component/cell.dart';

enum Direction { up, right, down, left }

class Snake extends SpriteComponent {
  final LinkedList<SnakeBodyPart> snakeBody = LinkedList();

  Direction direction = Direction.right;
  Cell head = Cell.zero;

  void move(Cell nextCell) {
    _removeLast();
    head = nextCell;
    _addFirst(head);
  }

  void grow(Cell nextCell) {
    head = nextCell;
    _addFirst(head);
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

  bool isHorizontal() {
    return direction == Direction.left || direction == Direction.right;
  }

  Vector2 displacementToHead(Vector2 reference) {
    return reference - head.location;
  }

  void addCell(Cell cell) {
    _add(SnakeBodyPart.fromCell(cell));
  }

  void _add(SnakeBodyPart part) {
    snakeBody.add(part);
  }

  void _addFirst(Cell cell) {
    snakeBody.addFirst(SnakeBodyPart.fromCell(cell));
  }

  void _removeLast() {
    snakeBody.last.cell.cellType = CellType.empty;
    snakeBody.remove(snakeBody.last);
  }
}
