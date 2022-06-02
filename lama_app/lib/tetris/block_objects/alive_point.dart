import 'point.dart';
import 'package:flutter/material.dart';

class AlivePoint extends Point {
  Color color;

  AlivePoint(double x, double y, this.color) : super(x, y);

  bool checkIfPointsCollide(List<Point> pointList) {
    bool retVal = false;

    for (var pointToCheck in pointList) {
      if (pointToCheck.x == x && pointToCheck.y == y - 1) {
        retVal = true;
      }
    }

    return retVal;
  }

//for rotation, if true, then rotate backwards
  bool checkIfPointsCollideCollide(List<Point> pointList) {
    bool retVal = false;

    for (var pointToCheck in pointList) {
      if (pointToCheck.x == x && pointToCheck.y == y) {
        retVal = true;
      }
    }

    return retVal;
  }
}
