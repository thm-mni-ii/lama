import 'package:flutter/material.dart';
import 'package:lama_app/snake/snakeGame.dart';

class GameScreen extends StatelessWidget {
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
                child: SnakeGame(context).widget,
                bottom: true,
              )
            )
          ]
        )
      )
    );
  }
}
