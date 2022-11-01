import 'dart:collection';

import '../component/cell.dart';

class SnakeBodyPart extends LinkedListEntry<SnakeBodyPart> {
  Cell cell;
  late int isHead;

  SnakeBodyPart(this.cell, this.isHead);

  factory SnakeBodyPart.fromCell(Cell cell, isHead) {
    if (isHead == 0) {
      cell.cellType = CellType.snakeHead;
    } else {
      cell.cellType = CellType.snakeBody;
    }
    return SnakeBodyPart(cell, isHead);
  }
}
