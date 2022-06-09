import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
//Lama defaults
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
//Blocs
import 'package:lama_app/app/bloc/check_screen_bloc.dart';
//Events
import 'package:lama_app/app/event/check_screen_event.dart';
//States
import 'package:lama_app/app/state/check_screen_state.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

///This file creates the Check Screen
///Check Screen is the first entry on app start
///This screen ensures that the DSGVO is accepted
///and an Admin User exist
///
/// * see also
///    [CheckScreenBloc]
///    [CheckScreenEvent]
///    [CheckScreenState]
///
/// Author: L.Kammerer
/// latest Changes: 15.07.2021
class CheckScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CheckScreenPage();
  }
}

///CheckScreenPage provides the state for the [CheckScreen]
class CheckScreenPage extends State<CheckScreen> {
  //used to ensure the check if an Admin exist
  bool _checkDone = false;
  @override
  void initState() {
    super.initState();
  }

  ///override build methode [StatelessWidget]
  ///
  ///{@param} [BuildContext] as context
  ///
  ///{@return} [Widget] decided by the incoming state of the [CheckScreenBloc]
  @override
  Widget build(BuildContext context) {
    ///if [_checkDone] is not true the [CheckForAdmin] event is triggert
    ///if the event is triggert [_checkDone] is set to true.
    if (!_checkDone) {
      context.read<CheckScreenBloc>().add(CheckForAdmin(context));
      _checkDone = true;
    }
    return Scaffold(
      body: BlocBuilder<CheckScreenBloc, CheckScreenState>(
        builder: (context, state) {
          ///view for the DSGVO
          ///if the user accept the DSGVO the [DSGVOAccepted] event is triggert
          ///which leads to another state
          if (state is ShowDSGVO) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Datenschutzgrundverordnung'),
                backgroundColor: LamaColors.bluePrimary,
              ),
              body: Column(
                children: [
                  Expanded(child: Markdown(data: state.dsgvo)),
                  ElevatedButton(
                    child: Row(
                      children: [
                        Icon(Icons.check_rounded),
                        SizedBox(width: 10),
                        Text(
                          'Akzeptieren',
                          style: LamaTextTheme.getStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(50, 60),
                      primary: LamaColors.bluePrimary,
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                    ),
                    onPressed: () {
                      context
                          .read<CheckScreenBloc>()
                          .add(DSGVOAccepted(context));
                    },
                  ),
                ],
              ),
            );
          }

          ///provides view which explain why ther should be an admin created
          ///also provides an [ElevatedButton] which triggers the [CreateAdminEvent] event
          ///to switch to the [CreateAdminScreen]
          ///
          /// * see also [CheckScreenBloc]
          if (state is CreateAdmin) {
            return Padding(
              padding: EdgeInsets.only(top: 200, left: 25, right: 25),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Für den einwandfreien Gebrauch der Anwendung muss ein Administrator-Konto angelegt werden!',
                      style: LamaTextTheme.getStyle(
                          fontSize: 14, color: LamaColors.black),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 25),
                    Container(
                      width: 250,
                      child: ElevatedButton(
                        child: Row(
                          children: [
                            Icon(Icons.save_sharp),
                            SizedBox(width: 10),
                            Text(
                              'Admin erstellen',
                              style: LamaTextTheme.getStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(50, 50),
                          primary: LamaColors.bluePrimary,
                          shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(0)),
                        ),
                        onPressed: () {
                          context
                              .read<CheckScreenBloc>()
                              .add(CreateAdminEvent(context));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is ShowWelcome) {
            final controller = PageController();
            final pages = getPages(controller);
            return Scaffold(
                body: Padding(
              padding: const EdgeInsets.fromLTRB(0, 25, 0, 5),
              child: Column(
                children: [
                  Flexible(
                    flex: 15,
                    child: PageView(
                      controller: controller,
                      children: pages,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            controller.jumpToPage(1);
                          },
                          child: Text("Übersicht"),
                        ),
                        Center(
                          child: SmoothPageIndicator(
                            controller: controller,
                            count: pages.length,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (controller.page == pages.length - 1) {
                              context
                                  .read<CheckScreenBloc>()
                                  .add(CreateAdminEvent(context));
                            } else {
                              controller.nextPage(
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.easeIn);
                            }
                          },
                          child: Icon(Icons.navigate_next),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
          }
          if (state is HasGuest) {
            context
                .read<CheckScreenBloc>()
                .add(LoadGuest(state.context, state.user));
          }

          ///default waiting screen with app icon
          return Container(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              'assets/images/svg/lama_head.svg',
              semanticsLabel: 'LAMA',
            ),
          );
        },
      ),
    );
  }

  List<Widget> getPages(PageController controller) {
    return [
      PageViewerModel(
        title: "Alles lernen mit Anna",
        description:
            "Mit dieser App ist Lernen interaktiv, belohnend und spaßig!"
            " Hier wird gezeigt wie die App funktioniert.",
        image: SvgPicture.asset(
          'assets/images/svg/app_icon.svg',
          semanticsLabel: 'LAMA',
        ),
      ),
      PageViewerModel(
        title: "Übersicht",
        description: "Was wollen Sie machen?",
        image: Image.asset("assets/images/png/sun.png"),
        button: ElevatedButton(
          onPressed: () {
            controller.jumpToPage(2);
          },
          child:
              Text("Go to Admin", style: LamaTextTheme.getStyle(fontSize: 15)),
        ),
        button2: ElevatedButton(
          onPressed: () {
            controller.jumpToPage(3);
          },
          child: Text(
            "Go to Gast",
            style: LamaTextTheme.getStyle(fontSize: 15),
          ),
        ),
      ),
      PageViewerModel(
          title: "Verwalte deine Schüler und ihre Aufgaben",
          description:
              "Es kann ein Admin angelegt werden, mit dem jeder Schüler einen "
              "eigenen Account mit Name, Passwort und Klasse erstellen kann. Es gibt "
              "pro Klasse ein Set an Standardaufgaben und die Möglichkeit, eigene "
              "Aufgaben nach einem Muster zu erstellen.",
          image: Image.asset('assets/images/png/admin_feature.png'),
          button: ElevatedButton(
            onPressed: () {
              controller.jumpToPage(1);
            },
            child: Text("Back to select",
                style: LamaTextTheme.getStyle(fontSize: 15)),
          ),
          button2: ElevatedButton(
            onPressed: () {
              context.read<CheckScreenBloc>().add(CreateAdminEvent(context));
            },
            child: Text("Erstelle Admin",
                style: LamaTextTheme.getStyle(fontSize: 15)),
          )),
      PageViewerModel(
          title: "Gast Seite",
          description: "Du möchtest als Gast weiter und einfach die "
              "Standardaufgaben ausprobieren? Einen Admin kann man später "
              "immernoch anlegen.",
          image: Image.asset('assets/images/png/features.png'),
          button: ElevatedButton(
            onPressed: () {
              controller.jumpToPage(1);
            },
            child: Text("Back to select",
                style: LamaTextTheme.getStyle(fontSize: 15)),
          ),
          button2: ElevatedButton(
            onPressed: () {
              context.read<CheckScreenBloc>().add(CreateGuestEvent(context));
            },
            child: Text("Weiter als Gast",
                style: LamaTextTheme.getStyle(fontSize: 15)),
          )),
      PageViewerModel(
        title: "Alles Verstanden?",
        description:
            "Wende dich bei Fragen an unser github und lese dir die dort "
            "verfügbaren PDF-Dateien durch! Wir wünschen dir viel Spaß mit der "
            "App!",
        image: Image.asset("assets/images/png/angrycloud.png"),
      )
    ];
  }

  Widget PageViewerModel(
      {String title,
      String description,
      var image,
      ElevatedButton button,
      ElevatedButton button2}) {
    return Column(
      children: [
        Flexible(
            flex: 2,
            child: Center(
              child: image,
            )),
        Flexible(
            flex: 3,
            child: Column(children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Text(
                  title,
                  style: LamaTextTheme.getStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                description,
                style: LamaTextTheme.getStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.normal),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: button,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: button2,
              ),
            ])),
      ],
    );
  }
}
