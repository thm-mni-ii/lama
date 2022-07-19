import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/flappyLama/flappyLamaGame.dart';

import '../../newFlappyLamaGame/baseFlappy.dart';
import '../../newFlappyLamaGame/flappyLamaMenu.dart';

///class that is a screen to open the tap the lama game and initialise a Navigator for the tap the lama gama so that the player can return in the game
class FlappyLamaScreen extends StatelessWidget {
  final UserRepository? userRepository;
  final int? userHighScore;
  final int? allTimeHighScore;

//Main Menu
  const FlappyLamaScreen(
      this.userRepository, this.userHighScore, this.allTimeHighScore);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Tap the Lama'),
      ),
      backgroundColor: Colors.white,
      body: Menu(context, userHighScore, allTimeHighScore, userRepository),
    );
  }
}

/// This class creates the Flappy Lama game screen
class FlappyGameScreen extends StatelessWidget {
  final UserRepository? userRepository;
  final int? userHighScore;
  final int? allTimeHighScore;
  const FlappyGameScreen(
      this.userRepository, this.userHighScore, this.allTimeHighScore);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Flappy Lama"),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
              Expanded(
                  child: Container(
                color: Colors.green,
                // child: FlappyLamaGame(context, userRepository).widget,
                child: GameWidget(
                  game: FlappyLamaGame2(context, userRepository!, userHighScore,
                      allTimeHighScore),
                ),
              ))
            ])));
  }
}
