import 'package:flutter/material.dart';
import '../tetrisGame.dart';
import 'point.dart';

class Block {
  // ignore: non_constant_identifier_names
  final fixed_length_list_of_points = List<Point>.filled(4, Point(0, 0));
  Point rotationCenter;
  Color color;

  void move(MoveDir dir) {
    switch (dir) {
      case MoveDir.LEFT:
        if (canMoveToSide(-(BOARD_WIDTH / 10))) {
          for (var p in fixed_length_list_of_points) {
            p.x -= 1;
          }
        }
        break;
      case MoveDir.RIGHT:
        if (canMoveToSide(BOARD_WIDTH / 10)) {
          for (var p in fixed_length_list_of_points) {
            p.x += 1;
          }
        }
        break;
      case MoveDir.DOWN:
        for (var p in fixed_length_list_of_points) {
          p.y += 1;
        }
        break;
    }
  }

  bool canMoveToSide(double moveAmt) {
    bool retVal = true;

    for (var point in fixed_length_list_of_points) {
      if (point.x + moveAmt < 0 || point.x + moveAmt >= BOARD_WIDTH) {
        retVal = false;
      }
    }
    return retVal;
  }

  bool allPointsInside() {
    bool retVal = true;

    for (var point in fixed_length_list_of_points) {
      if (point.x < 0 || point.x >= BOARD_WIDTH) {
        retVal = false;
      }
    }
    return retVal;
  }

  void rotateRight() {
    for (var point in fixed_length_list_of_points) {
      double x = point.x;
      point.x = rotationCenter.x - point.y + rotationCenter.y;
      point.y = rotationCenter.y + x - rotationCenter.x;
    }
    if (allPointsInside() == false) rotateLeft();
  }

  void rotateLeft() {
    for (var point in fixed_length_list_of_points) {
      double x = point.x;
      point.x = rotationCenter.x + point.y - rotationCenter.y;
      point.y = rotationCenter.y - x + rotationCenter.x;
    }
    if (allPointsInside() == false) rotateRight();
  }

  bool isAtBottom() {
    double lowestPoint = 0;

    for (var point in fixed_length_list_of_points) {
      if (point.y > lowestPoint) {
        lowestPoint = point.y;
      }
    }
    if (lowestPoint >= BOARD_HEIGHT - 1) {
      return true;
    } else {
      return false;
    }
  }
}
