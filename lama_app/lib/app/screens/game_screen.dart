import 'package:flutter/material.dart';
import 'package:lama_app/snake/snake_game.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SnakeGame game = SnakeGame();
    return game.widget;
  }
}
