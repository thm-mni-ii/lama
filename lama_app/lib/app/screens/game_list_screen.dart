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

class GameListScreen extends StatelessWidget {
  final List<GameListItem> games = [
    GameListItem("Snake", 2,
        "Steuer die Schlange mit den Pfeiltasten und sammle Früchte um länger zu werden!"),
    GameListItem("Flappy-Lama", 3,
        "Tippe auf den Bildschrim um das Lama fliegen zu lassen und weiche dabei den Hindernissen aus!"),
    /*GameListItem("Woodcutter", 2,
        "Tippe die entsprechende Richtung an um den Baum zu fällen und dabei den Ästen auszuweichen!"),*/
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<GameListScreenBloc, GameListScreenState>(
        listener: (context, state) {
          if (state is NotEnoughCoinsState) {
            final snackBar = SnackBar(
                backgroundColor: LamaColors.redAccent,
                content: Text(
                  'Du hast nicht genug Lama Münzen!',
                  textAlign: TextAlign.center,
                  style: LamaTextTheme.getStyle(fontSize: 15),
                ),
                duration: Duration(seconds: 1));
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: Container(
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
                        colors: [
                          LamaColors.greenAccent,
                          LamaColors.greenPrimary
                        ],
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
                            return buildGameList(context, index, constraints);
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
      ),
    );
  }

  Widget buildGameList(context, index, constraints) {
    Color color = LamaColors.orangeAccent;
    if (index % 2 == 0) color = LamaColors.blueAccent;
    return Container(
      height: (constraints.maxHeight / 100) * 25,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
      ),
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
