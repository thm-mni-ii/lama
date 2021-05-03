import 'package:flutter/material.dart';
import 'package:lama_app/app/screens/game_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(child: Text("Mathe"), onPressed: () => {}),
              ElevatedButton(
                child: Text("Snake"),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
