import 'package:flutter/material.dart';

import '../../tetris/tetrisGame.dart';
import '../../tetris/screens/tetrisMenu.dart';

import 'package:lama_app/app/repository/user_repository.dart';

// This class creates the Tetris game screen
// Author: Artur Pusch
// some parts of the code are taken from:
// https://github.com/DennisLovesCoffee/Flutter_Tetris
// wich was written by DennisLovesCoffee -- see also https://github.com/DennisLovesCoffee

class TetrisScreen extends StatelessWidget {
  final UserRepository userRepository;
  final int userHighScore;
  final int allTimeHighScore;

//Main Menu
  const TetrisScreen(
      this.userRepository, this.userHighScore, this.allTimeHighScore);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Wilkommen bei Tetris'),
      ),
      backgroundColor: Color.fromARGB(255, 27, 28, 27),
      body: Menu(context, userHighScore, allTimeHighScore, userRepository),
    );
  }
}

class GameScreen extends StatelessWidget {
  final UserRepository userRepository;
  final int userHighScore;
  final int allTimeHighScore;

  const GameScreen(
      this.userRepository, this.userHighScore, this.allTimeHighScore);

  // Gaming Screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Let\'s Tetris'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            //timer has to be canceled otherwise it runs on
            timer.cancel();
            //two pop's so user can reach the game_list_screen
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Color.fromARGB(255, 27, 28, 27),
      body: Game(context, userRepository, userHighScore, allTimeHighScore),
    );
  }
}
