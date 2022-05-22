import 'block.dart';
import 'point.dart';
import 'package:flutter/material.dart';

class IBlock extends Block {
  IBlock(double width) {
    fixed_length_list_of_points[0] =
        Point((width / 2 - 2).floor().toDouble(), -1);
    fixed_length_list_of_points[1] =
        Point((width / 2 - 1).floor().toDouble(), -1);
    fixed_length_list_of_points[2] =
        Point((width / 2 - 0).floor().toDouble(), -1);
    fixed_length_list_of_points[3] =
        Point((width / 2 + 1).floor().toDouble(), -1);
    rotationCenter = fixed_length_list_of_points[1];
    color = Colors.cyanAccent;
  }
}
