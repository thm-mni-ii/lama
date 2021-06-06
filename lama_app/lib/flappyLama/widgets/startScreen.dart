import 'package:flutter/material.dart';


class StartScreen extends StatelessWidget{

  final Function onStartPressed;
  const StartScreen(
    
    {@required this.onStartPressed}
  );
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/png/himmel.png'
            ),
            fit: BoxFit.cover,
          )
        ),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0)
            ),
            color: Color(0xffffffff),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal:  50.0,
                vertical: 100.0
                ),
              
            
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, 
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/png/snake.png'
                        ),
                      )
                    ),
                  ),
                  Text(
                    "Flappy Lama\n",
                    style: TextStyle(
                      color: Color(0xfff22222),
                      fontWeight: FontWeight.bold,
                      fontSize: 40.0,
                    ),
                  ),
                  Text(
                    "Drücke auf den Bildschirm,\num Anna ein wenig Auftrieb zu verleihen.\nVersuche dabei sowohl den Bildschirmrand, als auch die Kakteeen zu meiden.\n",
                    style: TextStyle(fontSize: 20.0)
                  ),
                  ElevatedButton(
                    child: Text(
                      "Start",
                      style: TextStyle(fontSize: 40.0),
                    ),
                    onPressed: () {
                      onStartPressed.call();
                    },
                  ),
                ],
              ),
            ),
          )
        ),
      ),
    );

  }

}