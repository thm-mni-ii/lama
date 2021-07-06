import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flutter/material.dart';

class ClimberBranch extends SpriteComponent {
  double opacity = 1;
  bool hit = false;

  void render(Canvas c) {
    if (opacity < 1 || hit) {
      var tmp = Paint();

      if (hit) {
        tmp.color = Colors.white.withOpacity(0.7);
      } else {
        tmp.color = Colors.white.withOpacity(opacity);
      }

      sprite.renderRect(
          c,
          Rect.fromLTWH(x, y, width, height),
          overridePaint: tmp
      );
    } else {
      super.render(c);
    }
  }
}