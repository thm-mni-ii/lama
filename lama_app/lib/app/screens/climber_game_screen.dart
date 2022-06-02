import 'package:flutter/material.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/apeClimber/climberGame.dart';

/// This class creates the Monkey Climber game screen
class ClimberGameScreen extends StatelessWidget {
  final UserRepository userRepository;

  const ClimberGameScreen(this.userRepository);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Affenleiter"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.green,
                child: ClimberGame(context, userRepository).widget,
              )
            )
          ]
        )
      )
    );
  }
}
