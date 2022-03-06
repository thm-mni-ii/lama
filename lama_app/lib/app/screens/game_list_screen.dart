import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lama_app/app/bloc/game_list_screen_bloc.dart';
import 'package:lama_app/app/event/game_list_screen_event.dart';
import 'package:lama_app/app/model/game_list_item_model.dart';
import 'package:lama_app/app/state/game_list_screen_state.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

///[StatelessWidget] that contains the Screen that displays all games.
///
///Author: K.Binder
class GameListScreen extends StatelessWidget {
  ///This list contains a [GameListItem] for each Game.
  ///
  ///If a new game is added, it will need to be "registered" here.
  static final List<GameListItem> games = [
    GameListItem("Snake", 16,
        "Steuer die Schlange mit den Pfeiltasten und sammle Äpfel, um länger zu werden!"),
    GameListItem("Flappy-Lama", 15,
        "Tippe auf den Bildschirm, um das Lama fliegen zu lassen und weiche dabei den Hindernissen aus!"),
    GameListItem("Affen-Leiter", 18,
        "Tippe die entsprechende Richtung an, um auf die andere Seite des Baumes zu springen und so den Ästen auszuweichen!"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [LamaColors.greenAccent, LamaColors.greenPrimary],
          ),
        ),
        child: SafeArea(
          child: Container(
            color: Colors.white,
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Column(children: [
                Container(
                  height: (constraints.maxHeight / 100) * 7.5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [LamaColors.greenAccent, LamaColors.greenPrimary],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          icon: Icon(
                            Icons.arrow_back,
                            size: 40,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      Text(
                        "Spiele",
                        style: LamaTextTheme.getStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return ListView.separated(
                        itemCount: games.length,
                        itemBuilder: (context, index) {
                          return buildGameListItem(context, index, constraints);
                        },
                        separatorBuilder: (context, index) => SizedBox(
                          height: (constraints.maxHeight / 100) * 5,
                        ),
                      );
                    }),
                  ),
                ),
              ]);
            }),
          ),
        ),
      ),
    );
  }

  ///Returns a Container with all information of a single [GameListItem]
  ///
  ///Used in the [build()] method for building the ListView
  Widget buildGameListItem(context, index, constraints) {
    Color color = LamaColors.orangeAccent;
    if (index % 2 == 0) color = LamaColors.blueAccent;
    return Container(
      height: (constraints.maxHeight / 100) * 25,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 2),
                blurRadius: 5,
                color: LamaColors.black.withOpacity(0.5))
          ]),
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    games[index].name,
                    style: LamaTextTheme.getStyle(fontSize: 30),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Text(
                          games[index].cost.toString(),
                          style: LamaTextTheme.getStyle(),
                        ),
                        SizedBox(width: 5),
                        SvgPicture.asset(
                          "assets/images/svg/lama_coin.svg",
                          semanticsLabel: "Lama Coin",
                          width: 25,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Text(
                games[index].desc,
                style: LamaTextTheme.getStyle(fontSize: 15),
              )
            ],
          ),
        ),
        onTap: () => BlocProvider.of<GameListScreenBloc>(context).add(
            TryStartGameEvent(games[index].cost, games[index].name, context)),
      ),
    );
  }
}
