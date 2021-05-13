import 'dart:ui';
import '../snake_game.dart';
import '../views/view.dart';

class StartButton {
  final SnakeGame game;

  RRect rect;
  Paint startPaint;

  StartButton(this.game, double relativeX, double relativeY) {
    var buttonOffset = [0.7, 0.1, 0.1, 0.1];

    rect = RRect.fromLTRBR(
      this.game.screenSize.width * buttonOffset[1],
      this.game.screenSize.height * buttonOffset[0],
      this.game.screenSize.width * (1.0 - buttonOffset[2]),
      this.game.screenSize.height * (buttonOffset[0] + buttonOffset[3]),
      Radius.circular(20.0),
    );

    startPaint = Paint();
    startPaint.color = Color(0xff6dff4a);
  }

  void render(Canvas c) {
    c.drawRRect(rect, startPaint);
  }

  void update(double t) {}

  void onTapDown() {
    game.activeView = View.playing;
  }
}
