import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';

import 'package:flutter/material.dart';

class ClimberBranch extends SpriteComponent with CollisionCallbacks {
  late ShapeHitbox hitbox;

  /// opacity of the hitbox
  double opacity = 1;

  /// flag to show the hitbox of the branch
  bool hit = true;

  void render(Canvas c) {
    if (opacity < 1 || hit) {
      // render hitbox
      sprite?.renderRect(c, Rect.fromLTWH(x, y, width, height),
          overridePaint: Paint()
            ..color = hit
                ? Colors.white.withOpacity(1.0)
                : Colors.red.withOpacity(0.7));
    } else {
      super.render(c);
    }
  }
}
