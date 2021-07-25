import 'dart:ui';
import 'package:flame/components/component.dart';
import 'package:lama_app/flappyLama/flappyLamaGame.dart';

class FlappyGround extends Component {
  final FlappyLamaGame game;
  Rect rectGrnd;
  Rect rectGrass;
  Size screenSize;
  Paint paintGrnd;
  Paint paintGrass;
  double groundY;

  FlappyGround(this.game) {
    groundY = 0.65 * game.screenSize.height;
    rectGrnd =
        Rect.fromLTWH(0, groundY, game.screenSize.width, game.tileSize * 6.5);
    rectGrass =
        Rect.fromLTWH(0, groundY, game.screenSize.width, game.tileSize * 0.75);
    paintGrnd = Paint();
    paintGrass = Paint();
    paintGrnd.color = Color(0xff5e3e29);
    paintGrass.color = Color(0xff65dc3e);
  }

  void render(Canvas c) {
    c.drawRect(rectGrnd, paintGrnd);
    c.drawRect(rectGrass, paintGrass);
  }

  void update(double t) {}
}
