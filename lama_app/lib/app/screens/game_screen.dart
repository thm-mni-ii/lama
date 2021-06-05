import 'package:flutter/material.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/snake/snakeGame.dart';

class GameScreen extends StatelessWidget {
  final UserRepository userRepository;

  const GameScreen(this.userRepository);

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
                child: SnakeGame(context, userRepository).widget,
                bottom: true,
              )
            )
          ]
        )
      )
    );
  }
}
