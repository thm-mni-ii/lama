import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lama_app/app/bloc/choose_taskset_bloc.dart';
import 'package:lama_app/app/bloc/create_admin_bloc.dart';
import 'package:lama_app/app/bloc/edit_user_bloc.dart';
import 'package:lama_app/app/bloc/game_list_screen_bloc.dart';
import 'package:lama_app/app/bloc/user_management_bloc.dart';
import 'package:lama_app/app/bloc/user_selection_bloc.dart';
import 'package:lama_app/app/repository/lamafacts_repository.dart';
import 'package:lama_app/app/repository/taskset_repository.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/app/screens/choose_taskset_screen.dart';
import 'package:lama_app/app/screens/edit_user_screen.dart';
import 'package:lama_app/app/screens/user_selection_screen.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
import 'package:lama_app/app/state/home_screen_state.dart';
import 'package:flutter_tts/flutter_tts.dart';


import 'game_list_screen.dart';
import 'package:lama_app/app/screens/task_type_screens/buchstabieren_task_helper.dart';

/// [StatefulWidget] that contains the main menu screen
///
/// This is a Stateful Widget so it can be reloaded using setState((){})
/// after Navigation, primarily to reflect changes to the lama coin amount.
///
/// Author: K.Binder
class HomeScreen extends StatefulWidget {
  String text = "";
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class ToggleTextToSpeech extends StatefulWidget {
  @override
  ToggleTextToSpeechWidget createState() => ToggleTextToSpeechWidget();
}

class ToggleTextToSpeechWidget extends State<ToggleTextToSpeech> {
  List<Widget> children = [];
  String path = home_screen_state.isTTs() ? "assets/images/svg/Ton.svg" : "assets/images/svg/Ton_Tod.svg";
  final FlutterTts flutterTts = FlutterTts();
  talk (String text) async {
    flutterTts.speak(text);
  }
  @override
  Widget build(BuildContext context) {
    talk(path);
    children.add(SizedBox(
        child: Stack(
            alignment: Alignment.topRight,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  child: CircleAvatar(
                    maxRadius: 29,
                    child: SvgPicture.asset(
                      path,
                    ),
                    backgroundColor: LamaColors.blueAccent,
                  ),
                  onTap: () {
                    home_screen_state.toggle();
                    setState(() {
                     // finaltooltipp = tooltipptext;
                      path = home_screen_state.isTTs() ? "assets/images/svg/Ton.svg" : "assets/images/svg/Ton_Tod.svg";
                    });
                  },
                ),
              ),

            ]
        ))
    );
    return children[0];
  }
}
/// [State] that contains the UI side logic for the [HomeScreen]
///
/// Author: K.Binder
class _HomeScreenState extends State<HomeScreen> {
  UserRepository? userRepository;

  DateTime? backButtonPressedTime;

  static String finaltooltipp = "";

  final snackBar = SnackBar(
      backgroundColor: LamaColors.mainPink,
      content: Text(
        'Zweimal drücken zum verlassen!',
        textAlign: TextAlign.center,
        style: LamaTextTheme.getStyle(fontSize: 15, color: LamaColors.white),
      ),
      duration: Duration(seconds: 1));

  @override
  Widget build(BuildContext context) {
    userRepository = RepositoryProvider.of<UserRepository>(context);
    String tooltipptext = RepositoryProvider.of<LamaFactsRepository>(context).getRandomLamaFact();
    if(finaltooltipp == "") {
      finaltooltipp = tooltipptext;
    } else {
      tooltipptext = finaltooltipp;
    }
    return Scaffold(
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Container(
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
                                      left:
                                          ((constraints.maxWidth / 100) * 2.5)),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: IconButton(
                                      padding: EdgeInsets.all(0),
                                      icon: Icon(
                                        Icons.logout,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                      onPressed: () =>
                                          Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BlocProvider(
                                            create: (BuildContext context) =>
                                                UserSelectionBloc(),
                                            child: UserSelectionScreen(),
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
                              child: descriptionButton(context, constraints),
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
                                  height: (constraints.maxHeight / 100) * 95,
                                  child: _buildMenuButtonColumn(constraints)),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: 15, bottom: 15),
                                child: SvgPicture.asset(
                                  "assets/images/svg/lama_head.svg",
                                  semanticsLabel: "Lama Anna",
                                  width: (constraints.maxWidth / 100) * 15,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: 20,
                                    right: (constraints.maxWidth / 100) * 15),
                                child: Container(
                                  height: (constraints.maxHeight / 100) * 10,
                                  width: (constraints.maxWidth / 100) * 80,
                                  child: Bubble(
                                    nip: BubbleNip.rightCenter,
                                    color: LamaColors.mainPink,
                                    borderColor: LamaColors.mainPink,
                                    shadowColor: LamaColors.black,
                                    child: Center(
                                      child: Text(
                                        tooltipptext,
                                        //RepositoryProvider.of<
                                        //        LamaFactsRepository>(context)
                                        //    .getRandomLamaFact(),
                                        style: LamaTextTheme.getStyle(
                                            fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
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
      ),
    );
  }

  /*Widget buildtooltip(BoxConstraints constraints) {
    Widget child;
    Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.only(
            bottom: 20,
            right: (constraints.maxWidth / 100) * 15),
        child: Container(
          height: (constraints.maxHeight / 100) * 10,
          width: (constraints.maxWidth / 100) * 80,
          child: Bubble(
            nip: BubbleNip.rightCenter,
            color: LamaColors.mainPink,
            borderColor: LamaColors.mainPink,
            shadowColor: LamaColors.black,
            child: Center(
              child: Text(
                RepositoryProvider.of<
                    LamaFactsRepository>(context)
                    .getRandomLamaFact(),
                style: LamaTextTheme.getStyle(
                    fontSize: 15),
              ),
            ),
          ),
        ),
      ),
    );
    return child;
  }*/
  ///if the user is a guest, the description turns into a button to edit user details
  ///after the user was changed, the userRepository gets updated
  Widget descriptionButton(BuildContext context, BoxConstraints constraints) {
    if (userRepository!.getGuestStatus()!) {
      return TextButton(
        child: Row(children: [
          userDescription(),
          SizedBox(width: 10),
          Icon(
            Icons.edit,
            color: LamaColors.white,
          )
        ]),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                      create: (BuildContext context) =>
                          EditUserBloc(userRepository!.authenticatedUser!)),
                  BlocProvider(
                      create: (BuildContext context) => UserManagementBloc()),
                ],
                child: EditUserScreen(userRepository!.authenticatedUser!),
              ),
            ),
          )
              .then((value) async => await userRepository!.updateUser())
              .then((value) => setState(
                    () {},
                  ));
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(0),
        ),
      );
    } else {
      return userDescription();
    }
  }

  ///Draws the Avatar and Username at the top of the screen
  Row userDescription() {
    return Row(
      children: [
        SizedBox(width: 10),
        CircleAvatar(
          child: SvgPicture.asset(
            'assets/images/svg/avatars/${userRepository!.getAvatar()}.svg',
            semanticsLabel: 'LAMA',
          ),
          radius: 25,
          backgroundColor: LamaColors.mainPink,
        ),
        SizedBox(width: 5),
        Text(
          userRepository!.getUserName()!,
          style: LamaTextTheme.getStyle(
              fontSize: 22.5, fontWeight: FontWeight.w600, monospace: true),
        ),
      ],
    );
  }

  ///Return a Widget that contains the complete center column with
  ///all subjects and the game button.
  ///
  ///Note that if no Tasksets are loaded for a specific combination
  ///(e.g. (Mathe, Grade 4)) the corresponding button will be emmited
  ///from the column.
  Widget _buildMenuButtonColumn(BoxConstraints constraints) {
    List<Widget> children = [];
    String path = home_screen_state.isTTs() ? "assets/images/svg/Ton.svg" : "assets/images/svg/Ton_Tod.svg";
    TasksetRepository tasksetRepository =
        RepositoryProvider.of<TasksetRepository>(context);
    if (tasksetRepository
            .getTasksetsForSubjectAndGrade("Mathe", userRepository!.getGrade())!
            .length >
        0) {
      //children.add(ToggleTextToSpeech());
      children.add(SizedBox(

          child: Stack(
            alignment: Alignment.topRight,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                      child: CircleAvatar(
                        maxRadius: 29,
                        child: SvgPicture.asset(
                          path,
                          semanticsLabel: 'TonIcon',
                        ),
                        backgroundColor: LamaColors.white,
                      ),
                    onTap: () {
                      home_screen_state.toggle();
                      setState(() {});
                    },
                  ),
                ),

              ]
          ))
      );
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
      //children.add(buildtooltip(constraints));
    }
    if (tasksetRepository
            .getTasksetsForSubjectAndGrade(
                "Deutsch", userRepository!.getGrade())!
            .length >
        0) {
      children.add(ElevatedButton(
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
                ((constraints.maxHeight / 100) * 10),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)))),
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (BuildContext context) =>
                      ChooseTasksetBloc(context.read<TasksetRepository>()),
                  child: ChooseTasksetScreen(
                      "Deutsch", userRepository!.getGrade(), userRepository),
                ),
              ),
            ).then((value) => (setState(() {})));

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
          }));
      children.add(SizedBox(height: (constraints.maxHeight / 100) * 2.5));
    }
    if (tasksetRepository
            .getTasksetsForSubjectAndGrade(
                "Englisch", userRepository!.getGrade())!
            .length >
        0) {
      children.add(ElevatedButton(
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
                  "Englisch", userRepository!.getGrade(), userRepository),
            ),
          ),
        ).then((value) => (setState(() {}))),
      ));
      children.add(SizedBox(height: (constraints.maxHeight / 100) * 2.5));
    }
    if (tasksetRepository
            .getTasksetsForSubjectAndGrade(
                "Sachkunde", userRepository!.getGrade())!
            .length >
        0) {
      children.add(ElevatedButton(
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
                  "Sachkunde", userRepository!.getGrade(), userRepository),
            ),
          ),
        ).then((value) => (setState(() {}))),
      ));
      children.add(SizedBox(height: (constraints.maxHeight / 100) * 2.5));
    }
    children.add(Container(
      height: ((constraints.maxHeight / 100) * 16),
      width: (constraints.maxWidth / 100) * 80,
      child: Stack(
        children: [
          Container(
            height: ((constraints.maxHeight / 100) * 10),
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
                      borderRadius: BorderRadius.all(Radius.circular(50)))),
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
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: ((constraints.maxHeight / 100) * 7.5),
              width: (constraints.maxWidth / 100) * 40,
              decoration: BoxDecoration(
                  color: LamaColors.greenPrimary,
                  borderRadius: BorderRadius.all(Radius.circular(50))),
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
                            semanticsLabel: 'LAMA'),
                      ),
                    ),
                    Text(userRepository!.getLamaCoins().toString(),
                        style: LamaTextTheme.getStyle(fontSize: 22.5)),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ));
    return Column(children: children);
  }

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
