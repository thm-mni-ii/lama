/* import 'dart:math';
import 'dart:ui';
import 'dart:developer' as developer;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/app/model/highscore_model.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:flutter/animation.dart';

enum PlayerState { crashed, jumping, running, waiting }

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameRef<NewFlappyGame>, CollisionCallbacks {
  Player() : super(size: Vector2(90, 88));

  // Métodos do jogador.
  void gravity(Vector2 target, double time) {
    super.position.moveToTarget(target, 2.5 * time * time);
  }

  void jump(double time) {
    super.position.moveToTarget(Vector2(super.position.x, 0), 100);
  }
}




enum LamaComponentState { idel, up, down }

class LamaComponent extends SpriteGroupComponent<LamaComponentState>
    with HasGameRef<NewFlappyGame> {
  @override
  Future<void> onLoad() async {
    final pressedSprite = await gameRef.loadSprite(
      'buttons.png',
      srcPosition: Vector2(0, 20),
      srcSize: Vector2(60, 20),
    );
    final unpressedSprite = await gameRef.loadSprite(
      'buttons.png',
      srcSize: Vector2(60, 20),
    );

/*    
    sprites = {
      LamaComponent.up: pressedSprite,
      LamaComponent.down: unpressedSprite,
    };

    current = LamaComponent.idel;
  } */
}



class NewFlappyGame extends FlameGame with TapDetector {
  late Player player;
  double time = 1;

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    // loads the spritesheet from assets
    final spriteSheet3 = SpriteSheet(
      image: await images.load('png/lama_animation.png'),
      srcSize: Vector2(16.0, 18.0),
    );

    // idle / hover animation
    final idleAnimation =
        spriteSheet3.createAnimation(row: 0, from: 0, to: 4, stepTime: 0.1);

    // up animation
    final upAnimation =
        spriteSheet3.createAnimation(row: 0, from: 5, to: 8, stepTime: 0.1);

    // fall animation
    final fallAnimation =
        spriteSheet3.createAnimation(row: 0, from: 9, to: 12, stepTime: 0.1);

    /*  final Sprite playerSprite =
        Sprite(await images.load('png/lama_animation.png')); */

    /*    final spriteSheet = SpriteSheet(
      image: 'png/lama_animation.png',
      textureWidth: 24,
      textureHeight: 24,
      columns: 12,
      rows: 1,
    ); */

    SpriteAnimation animation = idleAnimation;
    final Sprite playerSprite =
        Sprite(await images.load('png/lama_animation.png'));

/*     player = Player()
      ..sprite = playerSprite
      ..size = playerSprite.srcSize * 2
      ..position = size / 2
      ..anchor = Anchor.center;
    add(player); */
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
 */ 