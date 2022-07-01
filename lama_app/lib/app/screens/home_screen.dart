import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lama_app/app/bloc/choose_taskset_bloc.dart';
import 'package:lama_app/app/bloc/game_list_screen_bloc.dart';
import 'package:lama_app/app/bloc/user_selection_bloc.dart';
import 'package:lama_app/app/repository/lamafacts_repository.dart';
import 'package:lama_app/app/repository/taskset_repository.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/app/screens/choose_taskset_screen.dart';
import 'package:lama_app/app/screens/user_selection_screen.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

import 'game_list_screen.dart';
import 'package:lama_app/app/screens/task_type_screens/buchstabieren_task_helper.dart';

/// [StatefulWidget] that contains the main menu screen
///
/// This is a Stateful Widget so it can be reloaded using setState((){})
/// after Navigation, primarily to reflect changes to the lama coin amount.
///
/// Author: K.Binder
class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

/// [State] that contains the UI side logic for the [HomeScreen]
///
/// Author: K.Binder
class _HomeScreenState extends State<HomeScreen> {
  UserRepository? userRepository;

  DateTime? backButtonPressedTime;

  final snackBar = SnackBar(
    backgroundColor: LamaColors.mainPink,
    content: Text(
      'Zweimal drücken zum verlassen!',
      textAlign: TextAlign.center,
      style: LamaTextTheme.getStyle(fontSize: 15, color: LamaColors.white),
    ),
    duration: Duration(seconds: 1),
  );

  @override
  Widget build(BuildContext context) {
    userRepository = RepositoryProvider.of<UserRepository>(context);
    final screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: LamaColors.mainPink,
          leading: IconButton(
            icon: Icon(Icons.logout, size: 30),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (BuildContext context) => UserSelectionBloc(),
                  child: UserSelectionScreen(),
                ),
              ),
            ),
          ),
          title: Text(
            "Lerne alles mit Anna",
            style: LamaTextTheme.getStyle(fontSize: 18),
          ),
          toolbarHeight: screenSize.width / 5,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
        body: GridView(
          children: [
            for (var element in HomeScreenItems.listOfElements)
              Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        child: SvgPicture.asset(
                          element.imageUrl,
                          semanticsLabel: element.semanticsLabel,
                        ),
                        backgroundColor: element.backgroundColor,
                      ),
                      Text(element.itemText, style: LamaTextTheme.getStyle()),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: element.accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (BuildContext context) => ChooseTasksetBloc(
                            context.read<TasksetRepository>()),
                        child: ChooseTasksetScreen(
                          element.itemText,
                          userRepository!.getGrade(),
                          userRepository,
                        ),
                      ),
                    ),
                  ).then((value) => setState(() {})),
                ),
              ),
          ],
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(5),
          height: screenSize.height * 0.1,
          child: Row(
            children: [
              SizedBox(
                width: screenSize.width * 0.75,
                child: Bubble(
                  nip: BubbleNip.rightCenter,
                  color: LamaColors.mainPink,
                  borderColor: LamaColors.mainPink,
                  shadowColor: LamaColors.black,
                  child: Center(
                    child: Text(
                      RepositoryProvider.of<LamaFactsRepository>(context)
                          .getRandomLamaFact(),
                      style: LamaTextTheme.getStyle(fontSize: 15),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: screenSize.width * 0.2,
                child: SvgPicture.asset(
                  "assets/images/svg/lama_head.svg",
                  semanticsLabel: "Lama Anna",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
/* 
  ///Return a Widget that contains the complete center column with
  ///all subjects and the game button.
  ///
  ///Note that if no Tasksets are loaded for a specific combination
  ///(e.g. (Mathe, Grade 4)) the corresponding button will be emmited
  ///from the column.
  Widget _buildMenuButtonColumn(BoxConstraints constraints) {
    List<Widget> children = [];
    TasksetRepository tasksetRepository =
        RepositoryProvider.of<TasksetRepository>(context);

    if (tasksetRepository
            .getTasksetsForSubjectAndGrade("Mathe", userRepository!.getGrade())!
            .length >
        0) {
      children.add(ElevatedButton(
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
                child: SvgPicture.asset(
                  'assets/images/svg/MainMenu_Icons/mathe_icon.svg',
                  semanticsLabel: 'MatheIcon',
                ),
                backgroundColor: LamaColors.bluePrimary,
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
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (BuildContext context) =>
                  ChooseTasksetBloc(context.read<TasksetRepository>()),
              child: ChooseTasksetScreen(
                  "Mathe", userRepository!.getGrade(), userRepository),
            ),
          ),
        ).then((value) => (setState(() {}))),
      ));
      children.add(SizedBox(height: (constraints.maxHeight / 100) * 2.5));
    }
    if (tasksetRepository
            .getTasksetsForSubjectAndGrade(
                "Deutsch", userRepository!.getGrade())!
            .length >
        0) {
      children.add(
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
                  child: SvgPicture.asset(
                    'assets/images/svg/MainMenu_Icons/deutsch_icon.svg',
                    semanticsLabel: 'DeutschIcon',
                  ),
                  backgroundColor: LamaColors.redPrimary,
                ),
              )
            ],
          ),
          style: ElevatedButton.styleFrom(
            primary: LamaColors.redAccent,
            minimumSize: Size(
              (constraints.maxWidth / 100) * 80,
              (constraints.maxHeight / 100) * 10,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
          ),
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (BuildContext context) =>
                      ChooseTasksetBloc(context.read<TasksetRepository>()),
                  child: ChooseTasksetScreen(
                    "Deutsch",
                    userRepository!.getGrade(),
                    userRepository,
                  ),
                ),
              ),
            ).then((value) => setState(() {}));

            ///preloads the png urls in every buchstabieren task
            ///TO-DO: write method
            for (int j = 0;
                j <
                    tasksetRepository
                        .getTasksetsForSubjectAndGrade(
                            "Deutsch", userRepository!.getGrade())!
                        .length;
                j++) {
              TaskBuchstabieren buchTask;
              List<Task> buchTasks = tasksetRepository
                  .getTasksetsForSubjectAndGrade(
                      "Deutsch", userRepository!.getGrade())![j]
                  .tasks!
                  .where((element) => element.type == "Buchstabieren")
                  .toList();
              for (int i = 0; i < buchTasks.length; i++) {
                buchTask = buchTasks[i] as TaskBuchstabieren;
                await preloadPngs(context, buchTask.woerter);
              }
            }
          },
        ),
      );
      children.add(SizedBox(height: (constraints.maxHeight / 100) * 2.5));
    }
    if (tasksetRepository
            .getTasksetsForSubjectAndGrade(
                "Englisch", userRepository!.getGrade())!
            .length >
        0) {
      children.add(
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
                  child: SvgPicture.asset(
                    'assets/images/svg/MainMenu_Icons/englisch_icon.svg',
                    semanticsLabel: 'EnglischIcon',
                  ),
                  backgroundColor: LamaColors.orangePrimary,
                ),
              )
            ],
          ),
          style: ElevatedButton.styleFrom(
            primary: LamaColors.orangeAccent,
            minimumSize: Size(
              (constraints.maxWidth / 100) * 80,
              (constraints.maxHeight / 100) * 10,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
            ),
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (BuildContext context) =>
                    ChooseTasksetBloc(context.read<TasksetRepository>()),
                child: ChooseTasksetScreen(
                  "Englisch",
                  userRepository!.getGrade(),
                  userRepository,
                ),
              ),
            ),
          ).then((value) => setState(() {})),
        ),
      );
      children.add(SizedBox(height: (constraints.maxHeight / 100) * 2.5));
    }
    if (tasksetRepository
            .getTasksetsForSubjectAndGrade(
                "Sachkunde", userRepository!.getGrade())!
            .length >
        0) {
      children.add(
        ElevatedButton(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Text(
                  "Sachkunde",
                  style: LamaTextTheme.getStyle(),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: CircleAvatar(
                  child: SvgPicture.asset(
                    'assets/images/svg/MainMenu_Icons/sachkunde_icon.svg',
                    semanticsLabel: 'SachkundeIcon',
                  ),
                  backgroundColor: LamaColors.purplePrimary,
                ),
              )
            ],
          ),
          style: ElevatedButton.styleFrom(
            primary: LamaColors.purpleAccent,
            minimumSize: Size(
              (constraints.maxWidth / 100) * 80,
              (constraints.maxHeight / 100) * 10,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (BuildContext context) =>
                    ChooseTasksetBloc(context.read<TasksetRepository>()),
                child: ChooseTasksetScreen(
                  "Sachkunde",
                  userRepository!.getGrade(),
                  userRepository,
                ),
              ),
            ),
          ).then((value) => (setState(() {}))),
        ),
      );
      children.add(SizedBox(height: (constraints.maxHeight / 100) * 2.5));
    }
    children.add(
      Container(
        height: (constraints.maxHeight / 100) * 16,
        width: (constraints.maxWidth / 100) * 80,
        child: Stack(
          children: [
            Container(
              height: (constraints.maxHeight / 100) * 10,
              width: (constraints.maxWidth / 100) * 80,
              child: ElevatedButton(
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
                        child: SvgPicture.asset(
                          'assets/images/svg/MainMenu_Icons/spiel_icon.svg',
                          semanticsLabel: 'SpielIcon',
                        ),
                        backgroundColor: LamaColors.greenPrimary,
                      ),
                    )
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  primary: LamaColors.greenAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (BuildContext context) =>
                          GameListScreenBloc(userRepository),
                      child: GameListScreen(),
                    ),
                  ),
                ).then((value) => setState(() {})),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: (constraints.maxHeight / 100) * 7.5,
                width: (constraints.maxWidth / 100) * 40,
                decoration: BoxDecoration(
                  color: LamaColors.greenPrimary,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 25,
                          child: SvgPicture.asset(
                            'assets/images/svg/lama_coin.svg',
                            semanticsLabel: 'LAMA',
                          ),
                        ),
                      ),
                      Text(
                        userRepository!.getLamaCoins().toString(),
                        style: LamaTextTheme.getStyle(fontSize: 22.5),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
    return Column(children: children);
  } */

  ///Prevents leaving the app with a single press on the back button.
  ///
  ///This method is registered as a callback in the [build()] method.
  ///Then it decides based on the time between to presses, whether the
  ///app will exit or display a message.
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (backButtonPressedTime == null ||
        now.difference(backButtonPressedTime!) > Duration(seconds: 1)) {
      backButtonPressedTime = now;
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}

class HomeScreenItems {
  final String itemText;
  final String semanticsLabel;
  final String imageUrl;
  final Color backgroundColor;
  final Color accentColor;

  HomeScreenItems({
    required this.itemText,
    required this.semanticsLabel,
    required this.imageUrl,
    required this.backgroundColor,
    required this.accentColor,
  });

  static List<HomeScreenItems> listOfElements = [
    HomeScreenItems(
      itemText: "Mathe",
      imageUrl: 'assets/images/svg/MainMenu_Icons/mathe_icon.svg',
      semanticsLabel: 'MatheIcon',
      backgroundColor: LamaColors.bluePrimary,
      accentColor: LamaColors.blueAccent,
    ),
    HomeScreenItems(
      itemText: "Deutsch",
      imageUrl: 'assets/images/svg/MainMenu_Icons/deutsch_icon.svg',
      semanticsLabel: 'DeutschIcon',
      backgroundColor: LamaColors.redPrimary,
      accentColor: LamaColors.redAccent,
    ),
    HomeScreenItems(
      itemText: "Englisch",
      imageUrl: 'assets/images/svg/MainMenu_Icons/englisch_icon.svg',
      semanticsLabel: 'EnglischIcon',
      backgroundColor: LamaColors.orangePrimary,
      accentColor: LamaColors.orangeAccent,
    ),
    HomeScreenItems(
      itemText: "Sachkunde",
      imageUrl: 'assets/images/svg/MainMenu_Icons/sachkunde_icon.svg',
      semanticsLabel: 'SachkundeIcon',
      backgroundColor: LamaColors.purplePrimary,
      accentColor: LamaColors.purpleAccent,
    ),
    HomeScreenItems( // als trailing in appbar
      itemText: "Profile",
      imageUrl: 'assets/images/svg/MainMenu_Icons/mathe_icon.svg',
      semanticsLabel: 'MatheIcon',
      backgroundColor: LamaColors.bluePrimary,
      accentColor: LamaColors.blueAccent,
    ),
    HomeScreenItems(
      itemText: "Spiele",
      imageUrl: 'assets/images/svg/MainMenu_Icons/spiel_icon.svg',
      semanticsLabel: 'SpieleIcon',
      backgroundColor: LamaColors.greenPrimary,
      accentColor: LamaColors.greenAccent,
    ),
    HomeScreenItems(
      itemText: "Shop",
      imageUrl: 'assets/images/svg/lama_coin.svg',
      semanticsLabel: 'LAMA',
      backgroundColor: LamaColors.greenPrimary,
      accentColor: LamaColors.greenAccent,
    ),
    
  ];
}
