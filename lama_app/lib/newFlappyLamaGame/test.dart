import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';

class BasicAnimationsExample extends FlameGame with TapDetector {
  @override
  Color backgroundColor() => const Color(0xFFFFFFFF);
  static const description = '''
    Basic example of `SpriteAnimation`s use in Flame's `FlameGame`\n\n
    
    The snippet shows how an animation can be loaded and added to the game
    ```
    class MyGame extends FlameGame {
      @override
      Future<void> onLoad() async {
        final animation = await loadSpriteAnimation(
          'animations/chopper.png',
          SpriteAnimationData.sequenced(
            amount: 4,
            textureSize: Vector2.all(48),
            stepTime: 0.15,
          ),
        );
    
        final animationComponent = SpriteAnimationComponent(
          animation: animation,
          size: Vector2.all(100.0),
        );
    
        add(animationComponent);
      }
    }
    ```

    On this example, click or touch anywhere on the screen to dynamically add
    animations.
  ''';

  late Image creature;

  @override
  Future<void> onLoad() async {
    creature = await images.load('png/lama_animation.png');

    final animation = await loadSpriteAnimation(
      'png/lama_animation.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2.all(48),
        stepTime: 0.15,
      ),
    );

    final spriteSize = Vector2.all(100.0);
    final animationComponent = SpriteAnimationComponent(
      animation: animation,
      size: spriteSize,
    );
    animationComponent.x = size.x / 2 - spriteSize.x;
    animationComponent.y = spriteSize.y;

    add(animationComponent);
  }

  void addAnimation(Vector2 position) {
    final size = Vector2(291, 178);

    final animationComponent = SpriteAnimationComponent.fromFrameData(
      creature,
      SpriteAnimationData.sequenced(
        amount: 18,
        amountPerRow: 10,
        textureSize: size,
        stepTime: 2,
        loop: false,
      ),
      size: size,
      removeOnFinish: true,
    );

    animationComponent.position = position - size / 2;
    add(animationComponent);
  }

  Future<void> addAnimation2(Vector2 position) async {
    final spriteSheet = SpriteSheet(
      image: await images.load('png/lama_animation.png'),
      srcSize: Vector2(24.0, 24.0),
    );

    // idle / hover animation
    final _idleAnimation =
        spriteSheet.createAnimation(row: 0, from: 0, to: 4, stepTime: 0.1);

    // up animation
    final _upAnimation =
        spriteSheet.createAnimation(row: 0, from: 5, to: 8, stepTime: 0.1);

    final spriteSize = Vector2(80.0, 90.0);

    final _upComponent = SpriteAnimationComponent(
      animation: _upAnimation,
      position: Vector2(150, 100),
      size: spriteSize,
    );

    add(_upComponent);
  }

  @override
  void onTapDown(TapDownInfo info) {
    addAnimation2(info.eventPosition.game);
  }
}
