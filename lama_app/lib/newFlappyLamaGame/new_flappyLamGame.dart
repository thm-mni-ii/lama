import 'dart:math';
import 'dart:ui';
import 'dart:developer' as developer;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/app/model/highscore_model.dart';
import 'package:lama_app/app/repository/user_repository.dart';

class Player extends SpriteComponent {
  // Métodos do jogador.
  void gravity(Vector2 target, double time) {
    super.position.moveToTarget(target, 2.5 * time * time);
  }

  void jump(double time) {
    super.position.moveToTarget(Vector2(super.position.x, 0), 100);
  }
}

class NewFlappyGame extends FlameGame with TapDetector {
  late Player player;
  double time = 1;

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    final Sprite playerSprite =
        Sprite(await images.load('png/lama_animation.png'));

    player = Player()
      ..sprite = playerSprite
      ..size = playerSprite.srcSize * 2
      ..position = size / 2
      ..anchor = Anchor.center;
    add(player);
  }

  @override
  @mustCallSuper
  // ignore: must_call_super
  void update(dt) {
    time += log(1 + dt) / 100;
    // Puxa o player para baixo.
    player.gravity(Vector2(player.position.x, size.y), time);
    if (parent == null) {
      updateTree(dt);
    }
  }

  @override
  void onTap() {
    player.jump(time);
  }
}
