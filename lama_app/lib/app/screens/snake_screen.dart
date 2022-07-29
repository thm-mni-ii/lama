import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/app/repository/user_repository.dart';

import 'package:lama_app/game_snake_aus_iNet/snake_game.dart';

/// This class creates the Snake game screen
class SnakeScreen extends StatelessWidget {
  final UserRepository? userRepository;

  const SnakeScreen(this.userRepository);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Snake"),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
              Expanded(
                  child: SafeArea(
                child: GameWidget(
                  game: SnakeGame(),
                ),
                bottom: true,
              ))
            ])));
  }
}
