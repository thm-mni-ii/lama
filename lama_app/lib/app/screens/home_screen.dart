import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lama_app/app/bloc/choose_taskset_bloc.dart';
import 'package:lama_app/app/repository/taskset_repository.dart';
import 'package:lama_app/app/bloc/user_login_bloc.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/app/screens/choose_taskset_screen.dart';
import 'package:lama_app/app/screens/game_screen.dart';
import 'package:lama_app/app/screens/flappy_game_screen.dart';
import 'package:lama_app/app/screens/user_login_screen.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

//Home Screen is a Stateful Widget so it can be reloaded using setState((){}) after Navigation
class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    UserRepository userRepository =
        RepositoryProvider.of<UserRepository>(context);
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: LamaColors.mainPink,
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
                                style: LamaTextTheme.getStyle(),
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
                            primary: LamaColors.blueAccent,
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
                              child: ChooseTasksetScreen("Mathe",
                                  userRepository.getGrade(), userRepository),
                            ),
                          ),
                        ).then((value) => (setState(() {}))),
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
                                style: LamaTextTheme.getStyle(),
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
                            primary: LamaColors.redAccent,
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
                              child: ChooseTasksetScreen("Deutsch",
                                  userRepository.getGrade(), userRepository),
                            ),
                          ),
                        ).then((value) => (setState(() {}))),
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
                                style: LamaTextTheme.getStyle(),
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
                            primary: LamaColors.orangeAccent,
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
                              child: ChooseTasksetScreen("Englisch",
                                  userRepository.getGrade(), userRepository),
                            ),
                          ),
                        ).then((value) => (setState(() {}))),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //TODO: Remove buttons and add button for game list
                      ElevatedButton(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Center(
                              child: Text(
                                "Snake",
                                style: LamaTextTheme.getStyle(),
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
                            primary: LamaColors.greenAccent,
                            minimumSize: Size(screenSize.width / 1.25, 60),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)))),
                        onPressed: () => Navigator.push(
                          context,
                          //TODO: Change this to game screen 1
                          MaterialPageRoute(builder: (context) => GameScreen()),
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
                                "Flappy Lama",
                                style: LamaTextTheme.getStyle(),
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
                            primary: LamaColors.greenAccent,
                            minimumSize: Size(screenSize.width / 1.25, 60),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)))),
                        onPressed: () => Navigator.push(
                          context,
                          //TODO: Change this to GameScreen for game 2
                          MaterialPageRoute(
                              builder: (context) => FlappyGameScreen()),
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
                  color: LamaColors.mainPink,
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
                    style: LamaTextTheme.getStyle(),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userRepository.getUserName(),
                          style: LamaTextTheme.getStyle(
                              fontSize: 22.5,
                              fontWeight: FontWeight.w600,
                              monospace: true),
                        ),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                userRepository.getLamaCoins().toString(),
                                style: LamaTextTheme.getStyle(fontSize: 20),
                              ),
                              SizedBox(width: 5),
                              SvgPicture.asset(
                                "assets/images/svg/lama_coin.svg",
                                semanticsLabel: "Lama Coin",
                                width: 20,
                              )
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
