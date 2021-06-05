import 'package:flutter/material.dart';


class StartScreen extends StatelessWidget{
  final Function onStartPressed;
  const StartScreen(
    {@required this.onStartPressed}
  );
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: Container(
          color: Color(0xffffffff),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Flieg in die Höhe cooles Lama",
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
      ),
    );

  }

}