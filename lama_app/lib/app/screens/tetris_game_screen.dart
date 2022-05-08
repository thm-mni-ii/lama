// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import '../../tetris/game.dart';
import '../../tetris/menu.dart';
import 'package:lama_app/app/repository/user_repository.dart';

class TetrisScreen extends StatelessWidget {
  final UserRepository userRepository;

  const TetrisScreen(this.userRepository);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Wilkommen bei Tetris'),
      ),
      backgroundColor: Color.fromARGB(255, 27, 28, 27),
      body: Menu(context, userRepository),
    );
  }
}

class GameScreen extends StatelessWidget {
  final UserRepository userRepository;

  const GameScreen(this.userRepository);

  // const GameScreen({Key? key}) : super(key: key);
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
            timer.cancel();
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Color.fromARGB(255, 27, 28, 27),
      body: Game(context, userRepository),
    );
  }
}
