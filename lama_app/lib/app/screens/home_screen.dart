import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/choose_taskset_bloc.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/repository/taskset_repository.dart';
import 'package:lama_app/app/bloc/user_login_bloc.dart';
import 'package:lama_app/app/screens/choose_taskset_screen.dart';
import 'package:lama_app/app/screens/game_screen.dart';
import 'package:lama_app/app/screens/user_login_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen();
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
                child: Container(
                  width: screenSize.width / 1.25,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Center(
                              child: Text(
                                "Mathe",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 60, 223, 255),
                              ),
                            )
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 112, 231, 255),
                            minimumSize: Size(screenSize.width / 1.25, 60),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)))),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (BuildContext context) =>
                                  ChooseTasksetBloc(
                                      context.read<TasksetRepository>()),
                              child: ChooseTasksetScreen("Mathe"),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Center(
                              child: Text(
                                "Deutsch",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 239, 30, 50),
                              ),
                            )
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 239, 30, 6),
                            minimumSize: Size(screenSize.width / 1.25, 60),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)))),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (BuildContext context) =>
                                  ChooseTasksetBloc(
                                      context.read<TasksetRepository>()),
                              child: ChooseTasksetScreen("Deutsch"),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Center(
                              child: Text(
                                "Englisch",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 239, 30, 50),
                              ),
                            )
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 253, 130, 53),
                            minimumSize: Size(screenSize.width / 1.25, 60),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)))),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (BuildContext context) =>
                                  ChooseTasksetBloc(
                                      context.read<TasksetRepository>()),
                              child: ChooseTasksetScreen("Englisch"),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Center(
                              child: Text(
                                "Spiele",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 239, 30, 50),
                              ),
                            )
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 253, 74, 111),
                            minimumSize: Size(screenSize.width / 1.25, 60),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)))),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GameScreen()),
                        ),
                      ),
                    ],
                  ),
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "GigaKaninchen",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        Row(children: [
                          Text(
                            "450",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          SizedBox(width: 5),
                          CircleAvatar(radius: 10)
                        ])
                      ],
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: ElevatedButton(
                child: Text("User select test"),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (BuildContext context) => UserLoginBloc(),
                      child: UserLoginScreen(),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
