import 'package:lama_app/flappyLama/flappyLamaGame.dart';
import 'dart:ui';

class GameOverView {
  final FlappyLamaGame game;
  Paint bgPaint;
  Rect bgRect;

  GameOverView(this.game) {
    resize();
    bgPaint = Paint()..color = Color(0xFF4A7AEA);
  }

  void render(Canvas c) {
    c.drawRect(bgRect, bgPaint);
  }

  void update(Canvas c) {}

  void resize() {
    bgRect = Rect.fromLTWH(
      this.game.tileSize * 1,
      this.game.tileSize * 1,
      this.game.screenSize.width - this.game.tileSize * 2,
      this.game.tileSize * 10,
    );
  }
}
