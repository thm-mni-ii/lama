import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lama_app/app/screens/welcome_screen.dart';
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
            return Scaffold(
                body: Padding(
              padding: const EdgeInsets.fromLTRB(0, 25, 0, 5),
              child: Column(
                children: [
                  Flexible(
                    flex: 15,
                    child: PageView(
                      controller: controller,
                      children: [
                        PageViewerModel(
                          title: "Erste Seite",
                          description:
                              "Welcome welcome zu der Lama app, hier geht es richtig ab",
                          image: Image.asset("assets/images/png/sunrise.png"),
                        ),
                        PageViewerModel(
                          title: "Zweite Seite",
                          description: "Hier gibts nen button zum admin!!",
                          image: Image.asset("assets/images/png/sun.png"),
                        ),
                        PageViewerModel(
                          title: "Dritte Seite",
                          description:
                              "Hier kann man einen Admin erstellen woooow",
                          image: Image.asset("assets/images/png/sunset.png"),
                        ),
                        PageViewerModel(
                          title: "ich bin der titel",
                          description: "Ich bin die letzte Seite",
                          image:
                              Image.asset("assets/images/png/angrycloud.png"),
                        )
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            controller.jumpToPage(3);
                          },
                          child: Text("Skip"),
                        ),
                        Center(
                          child: SmoothPageIndicator(
                            controller: controller,
                            count: 4,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<CheckScreenBloc>()
                                .add(CreateAdminEvent(context));
                          },
                          child: Icon(Icons.navigate_next),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
                /* body: IntroductionScreen(
              pages: [
                PageViewModel(
                  title: "Placeholder Pagetitle 1",
                  body: "Placeholder bodytext 1",
                  footer: Text(
                    "Footer Placeholder",
                  ),
                  image: Image.asset("assets/images/png/sunrise.png"),
                ),
                PageViewModel(
                  title: "Placeholder Pagetitle 1",
                  body: "Placeholder bodytext 2",
                  footer: ElevatedButton(
                    child: Text("Goto Admin Page"),
                    onPressed: () {
                      context
                          .read<CheckScreenBloc>()
                          .add(GotoAdminEvent(context));
                    }, //do something when pressed
                  ),
                  image: Image.asset("assets/images/png/sun.png"),
                ),
                PageViewModel(
                  title: "Placeholder Pagetitle 3",
                  body: "Placeholder bodytext 3",
                  image: Image.asset("assets/images/png/sunset.png"),
                  footer: ElevatedButton(
                    child: Text("Erstelle Admin"),
                    onPressed: () {
                      context
                          .read<CheckScreenBloc>()
                          .add(CreateAdminEvent(context));
                    }, //do something when pressed
                  ),
                ),
                PageViewModel(
                  title: "Placeholder Pagetitle LAST",
                  body: "Viel spaß mit der App",
                  image: Image.asset("assets/images/png/sunrise.png"),
                ),
              ],
              done: Text("Los geht's"),
              skip: Text("skip"),
              showSkipButton: true,
              next: Icon(Icons.navigate_next),
              onDone: () {
                context.read<CheckScreenBloc>().add(CreateAdminEvent(context));
              }, //TO-DO what happens when clicking "done"
            ) */
                );
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

  Widget PageViewerModel({String title, String description, Image image}) {
    return Column(
      children: [
        Flexible(
            flex: 4,
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
            ])),
      ],
    );
  }
}
