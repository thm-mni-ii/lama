import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'climberGame2.dart';

class ApeClimberParallaxComponent extends ParallaxComponent<ApeClimberGame> {
  @override
  Future<void> onLoad() async {
    parallax = await gameRef.loadParallax(
      [
        ParallaxImageData('png/himmel.png'),
        ParallaxImageData('png/clouds_3.png'),
        ParallaxImageData('png/clouds_2.png'),
        ParallaxImageData('png/clouds.png'),
      ],
      baseVelocity: Vector2(3, 0),
      velocityMultiplierDelta: Vector2(1.8, 1.0),
    );
  }
}
