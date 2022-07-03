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
import 'package:lama_app/app/screens/game_list_screen.dart';
import 'package:lama_app/app/screens/user_selection_screen.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

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

    Widget screenDependingOnButtomItem(String elementText) {
      switch (elementText) {
        case "Spiele":
          return BlocProvider(
            create: (BuildContext context) =>
                GameListScreenBloc(userRepository),
            child: GameListScreen(),
          );
        case "Mathe":
        case "Deutsch":
        case "Englisch":
        case "Sachkunde":
          return BlocProvider(
            create: (BuildContext context) => ChooseTasksetBloc(
              context.read<TasksetRepository>(),
            ),
            child: ChooseTasksetScreen(
              elementText,
              userRepository!.getGrade(),
              userRepository,
            ),
          );
        case "Shop":
        // screen muss erst noch implementiert werden
        default:
          return Placeholder();
      }
    }

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
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Center(
                child: Text(
                  userRepository!.getUserName()!,
                  style: LamaTextTheme.getStyle(),
                ),
              ),
            ),
          ],
          title: Text(
            "Lerne alles mit Anna",
            style: LamaTextTheme.getStyle(fontSize: 25),
          ),
          toolbarHeight: screenSize.width / 5,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            GridView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          child: SvgPicture.asset(
                            'assets/images/svg/avatars/${userRepository!.getAvatar()}.svg',
                            semanticsLabel: 'LAMA',
                          ),
                        ),
                        Text(
                          "Profile",
                          style: LamaTextTheme.getStyle(),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: LamaColors.profileColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                    ),
                    onPressed: () {},// zu implementieren
                  ),
                ),
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
                          Text(
                            element.itemText,
                            style: LamaTextTheme.getStyle(),
                          ),
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
                          builder: (context) =>
                              screenDependingOnButtomItem(element.itemText),
                        ),
                      ).then((value) => setState(() {})),
                    ),
                  ),
              ],
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
            ),
            Container(
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
          ],
        ),
        /* bottomNavigationBar: Container(color: Colors.transparent,
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
        ), */
      ),
    );
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
      backgroundColor: LamaColors.shopColor,
      accentColor: LamaColors.shopColor,
    ),
  ];
}
