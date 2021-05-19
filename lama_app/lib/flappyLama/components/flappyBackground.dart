import 'dart:ui';
import 'package:lama_app/flappyLama/flappyLamaGame.dart';

class FlappyBackground {
  final FlappyLamaGame game;
  Rect bgRect;
  Size screenSize;
  Paint bgPaint;

  FlappyBackground(this.game) {
    bgRect = Rect.fromLTWH(0, 0, game.screenSize.width, game.screenSize.height);
    bgPaint = Paint();
    bgPaint.color = Color(0xff82e5ff);
  }

  void render(Canvas c) {
    c.drawRect(bgRect, bgPaint);
  }

  void update(double t) {}
}
