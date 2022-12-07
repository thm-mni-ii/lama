import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/app/repository/user_repository.dart';

import 'package:lama_app/game_snake_aus_iNet/snake_game.dart';

import '../../game_snake_aus_iNet/snakeMenu.dart';

/// This class creates the Snake game screen
class SnakeScreen extends StatelessWidget {
  final UserRepository? userRepository;
  final int? userHighScore;
  final int? allTimeHighScore;

  const SnakeScreen(
      this.userRepository, this.userHighScore, this.allTimeHighScore);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Snake'),
      ),
      backgroundColor: Colors.white,
      body: Menu(context, userHighScore, allTimeHighScore, userRepository),
    );
  }

  //game: SnakeGame(),
}

class SnakeGameScreen extends StatelessWidget {
  final UserRepository? userRepository;
  final int? userHighScore;
  final int? allTimeHighScore;

  const SnakeGameScreen(
      this.userRepository, this.userHighScore, this.allTimeHighScore);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Snake"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              //two pop's so user can reach the game_list_screen
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
              Expanded(
                  child: Container(
                      color: Colors.white,
                      child: GameWidget(
                        game: SnakeGame(context, userRepository!, userHighScore,
                            allTimeHighScore),
                      )))
            ])));
  }
}
