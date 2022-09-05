import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:lama_app/newFlappyLamaGame/baseFlappy.dart';

class MyParallaxComponent extends ParallaxComponent<FlappyLamaGame2> {
  @override
  Future<void> onLoad() async {
    parallax = await gameRef.loadParallax(
      [
        ParallaxImageData('png/himmel.png'),
        ParallaxImageData('png/clouds_3.png'),
        ParallaxImageData('png/clouds_2.png'),
        ParallaxImageData('png/clouds.png'),
      ],
      baseVelocity: Vector2(7, 0),
      velocityMultiplierDelta: Vector2(1.8, 1.0),
    );
  }
}
