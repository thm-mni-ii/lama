import 'dart:collection';

import '../component/cell.dart';

class SnakeHeadPart extends LinkedListEntry<SnakeHeadPart> {
  late Cell cell;

  SnakeHeadPart(this.cell);

  factory SnakeHeadPart.fromCell(Cell cell) {
    cell.cellType = CellType.snakeHead;
    return SnakeHeadPart(cell);
  }
}
