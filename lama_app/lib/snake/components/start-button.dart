import 'dart:ui';
import '../snake_game.dart';
import '../view.dart';

class StartButton {
  final SnakeGame game;
  Rect rect;
  Paint startPaint;

  StartButton(this.game) {
    rect = Rect.fromLTWH(
      game.tileSize * 2,
      (game.screenSize.height * .75) - (game.tileSize * 1.5),
      game.tileSize * 5,
      game.tileSize * 2,
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
