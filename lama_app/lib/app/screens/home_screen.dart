import 'package:flutter/material.dart';
import 'package:lama_app/app/screens/game_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 253, 74, 111),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Colors.white,
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
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: screenSize.width,
                height: 75,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 253, 74, 111),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 2,
                        offset: Offset(0, 2),
                        spreadRadius: 1,
                        color: Colors.grey)
                  ],
                ),
                child: Center(
                  child: Text(
                    "Lerne alles mit Anna",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: screenSize.width / 1.5,
                margin: EdgeInsets.only(top: 60),
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 5,
                        color: Colors.black,
                        offset: Offset(0, 2))
                  ],
                  color: Color.fromARGB(255, 253, 74, 111),
                ),
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "GigaKaninchen",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
