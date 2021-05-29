import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lama_app/app/bloc/choose_taskset_bloc.dart';
import 'package:lama_app/app/bloc/game_list_screen_bloc.dart';
import 'package:lama_app/app/repository/taskset_repository.dart';
import 'package:lama_app/app/bloc/user_login_bloc.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/app/screens/choose_taskset_screen.dart';
import 'package:lama_app/app/screens/game_screen.dart';
import 'package:lama_app/app/screens/flappy_game_screen.dart';
import 'package:lama_app/app/screens/user_login_screen.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

import 'game_list_screen.dart';

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
    /*return Scaffold(
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
                      ElevatedButton(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Center(
                              child: Text(
                                "Spiele",
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
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (BuildContext context) =>
                                  GameListScreenBloc(userRepository),
                              child: GameListScreen(),
                            ),
                          ),
                        ).then((value) => (setState(() {}))),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Stack(children: [
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
                  child: Stack(children: [
                    Center(
                      child: Text(
                        "Lerne alles mit Anna",
                        style: LamaTextTheme.getStyle(),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          icon: Icon(
                            Icons.logout,
                            size: 30,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (BuildContext context) =>
                                    UserLoginBloc(),
                                child: UserLoginScreen(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ]),
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
                      child: SvgPicture.asset(
                        'assets/images/svg/avatars/${userRepository.getAvatar()}.svg',
                        semanticsLabel: 'LAMA',
                      ),
                      radius: 25,
                      backgroundColor: LamaColors.mainPink,
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
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(right: 15, bottom: 15),
                child: SvgPicture.asset(
                  "assets/images/svg/lama_head.svg",
                  semanticsLabel: "Lama Anna",
                  width: (screenSize.width / 100) * 15,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: 20, right: (screenSize.width / 100) * 15),
                child: Container(
                  height: (screenSize.height / 100) * 10,
                  width: (screenSize.width / 100) * 80,
                  child: Bubble(
                    nip: BubbleNip.rightCenter,
                    color: LamaColors.mainPink,
                    borderColor: LamaColors.mainPink,
                    shadowColor: LamaColors.black,
                    child: Center(
                      child: Text(
                        "Lamas können gut klettern!",
                        style: LamaTextTheme.getStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );*/
    return Scaffold(
      body: Container(
        color: LamaColors.mainPink,
        child: SafeArea(
          child: Container(
            color: Colors.white,
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Column(
                children: [
                  Container(
                    height: (constraints.maxHeight / 100) * 17.5,
                    child: Stack(
                      children: [
                        Container(
                          height: (constraints.maxHeight / 100) * 10,
                          decoration: BoxDecoration(
                            color: LamaColors.mainPink,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: ((constraints.maxWidth / 100) * 2.5)),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: IconButton(
                                    padding: EdgeInsets.all(0),
                                    icon: Icon(
                                      Icons.logout,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                    onPressed: () => Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BlocProvider(
                                          create: (BuildContext context) =>
                                              UserLoginBloc(),
                                          child: UserLoginScreen(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Text("Lerne alles mit Anna",
                                  style: LamaTextTheme.getStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: (constraints.maxHeight / 100) * 10,
                            width: (constraints.maxWidth / 100) * 60,
                            decoration: BoxDecoration(
                              color: LamaColors.mainPink,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  child: SvgPicture.asset(
                                    'assets/images/svg/avatars/${userRepository.getAvatar()}.svg',
                                    semanticsLabel: 'LAMA',
                                  ),
                                  radius: 25,
                                  backgroundColor: LamaColors.mainPink,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "RoterAffe3",
                                  style: LamaTextTheme.getStyle(
                                      fontSize: 22.5,
                                      fontWeight: FontWeight.w600,
                                      monospace: true),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return Stack(
                        children: [
                          Center(
                            child: Container(
                                width: (constraints.maxWidth / 100) * 75,
                                height: (constraints.maxHeight / 100) * 75,
                                child: _buildMenuButtonColumn(constraints)),
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButtonColumn(BoxConstraints constraints) {
    return Column(
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
                  backgroundColor: LamaColors.mainPink,
                ),
              )
            ],
          ),
          style: ElevatedButton.styleFrom(
              primary: LamaColors.blueAccent,
              minimumSize: Size(
                (constraints.maxWidth / 100) * 80,
                ((constraints.maxHeight / 100) * 10),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)))),
          onPressed: () {},
        ),
        SizedBox(height: (constraints.maxHeight / 100) * 2.5),
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
                  backgroundColor: LamaColors.mainPink,
                ),
              )
            ],
          ),
          style: ElevatedButton.styleFrom(
              primary: LamaColors.redAccent,
              minimumSize: Size(
                (constraints.maxWidth / 100) * 80,
                ((constraints.maxHeight / 100) * 10),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)))),
          onPressed: () {},
        ),
        SizedBox(height: (constraints.maxHeight / 100) * 2.5),
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
                  backgroundColor: LamaColors.mainPink,
                ),
              )
            ],
          ),
          style: ElevatedButton.styleFrom(
              primary: LamaColors.orangeAccent,
              minimumSize: Size(
                (constraints.maxWidth / 100) * 80,
                ((constraints.maxHeight / 100) * 10),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)))),
          onPressed: () {},
        ),
        SizedBox(height: (constraints.maxHeight / 100) * 2.5),
        ElevatedButton(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Text(
                  "Spiele",
                  style: LamaTextTheme.getStyle(),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: CircleAvatar(
                  backgroundColor: LamaColors.mainPink,
                ),
              )
            ],
          ),
          style: ElevatedButton.styleFrom(
              primary: LamaColors.greenAccent,
              minimumSize: Size(
                (constraints.maxWidth / 100) * 80,
                ((constraints.maxHeight / 100) * 10),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)))),
          onPressed: () {},
        )
      ],
    );
  }
}
