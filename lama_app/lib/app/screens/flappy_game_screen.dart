import 'package:flutter/material.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/flappyLama/flappyLamaGame.dart';

/// This class creates the Flappy Lama game screen
class FlappyGameScreen extends StatelessWidget {
  final UserRepository userRepository;

  const FlappyGameScreen(this.userRepository);

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
                child: FlappyLamaGame(context, userRepository).widget,
              )
            )
          ]
        )
      )
    );
  }
}
