import 'dart:ui';
import '../snake_game.dart';
import '../views/view.dart';

class StartButton {
  final SnakeGame game;
  Rect rect;
  Paint startPaint;

  StartButton(this.game) {
    rect = Rect.fromLTWH(
      game.tileSize * 7.5,
      (game.screenSize.height / 2) + (game.tileSize * 2.5),
      game.tileSize * 16,
      game.tileSize * 9,
    );
    startPaint = Paint();
    startPaint.color = Color(0xff6dff4a);
  }

  void render(Canvas c) {
    c.drawRect(rect, startPaint);
  }

  void update(double t) {}

  void onTapDown() {
    game.activeView = View.playing;
  }
}
