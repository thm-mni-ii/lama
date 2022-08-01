import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lama_app/app/bloc/check_screen_bloc.dart';
import 'package:lama_app/app/bloc/taskset_options_bloc.dart';
import 'package:lama_app/app/bloc/userlist_url_bloc.dart';

import 'package:lama_app/app/event/check_screen_event.dart';
import 'package:lama_app/app/event/taskset_options_event.dart';
import 'package:lama_app/app/event/userlist_url_event.dart';
import 'package:lama_app/app/repository/taskset_repository.dart';
import 'package:lama_app/app/state/check_screen_state.dart';
import 'package:lama_app/app/state/taskset_options_state.dart';
import 'package:lama_app/app/state/userlist_url_state.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = PageController();
    final pages = getPages(controller);

    ///listens to [CheckSCreenBloc], [UserlistUrlBloc] and
    ///[TasksetOptionsBloc] to add the right events when inserting the SetupUrl
    return MultiBlocListener(
      listeners: [
        BlocListener<CheckScreenBloc, CheckScreenState?>(
          listener: (context, state) {
            if (state is LoadSetup) {
              BlocProvider.of<TasksetOptionsBloc>(context)
                ..add(TasksetOptionsChangeURL(state.tasksetUrl!))
                ..add(TasksetOptionsPush(false));

              BlocProvider.of<UserlistUrlBloc>(context)
                ..add(UserlistUrlChangeUrl(state.userlistUrl!))
                ..add(UserlistParseUrl());
            }
            if (state is HasGuest) {
              context
                  .read<CheckScreenBloc>()
                  .add(LoadGuest(context, state.user, false));
            }
            if (state is SetupError) {
              showDialog(
                  context: context,
                  builder: (_) =>
                      _insertErrorPopUp(state.errorMessage, state.errorType));
            }
            if (state is SetupSuccessState) {
              BlocProvider.of<TasksetOptionsBloc>(context)
                  .add(TasksetOptionsPush(true));
              BlocProvider.of<UserlistUrlBloc>(context)
                  .add(UserlistInsertList());
              /* RepositoryProvider.of<TasksetRepository>(context)
                  .reloadTasksetLoader(); */
              context.read<CheckScreenBloc>().add(CheckForAdmin(context));
            }
          },
        ),
        BlocListener<UserlistUrlBloc, UserlistUrlState?>(
          listener: (context, state) {
            if (state is UserlistUrlParsingSuccessfull) {
              BlocProvider.of<CheckScreenBloc>(context)
                  .add(UrlCheckSuccess(true));
            }
            if (state is UserlistUrlParsingFailed) {
              BlocProvider.of<CheckScreenBloc>(context)
                  .add(DisplaySetupError(state.error, "Nutzerliste"));

              /* BlocProvider.of<TasksetOptionsBloc>(context)
                  .add(TasksetOptionsDelete()); */
            }
          },
        ),
        BlocListener<TasksetOptionsBloc, TasksetOptionsState?>(
          listener: (context, state) {
            if (state is TasksetOptionsPushSuccess) {
              BlocProvider.of<CheckScreenBloc>(context)
                  .add(UrlCheckSuccess(false));
              RepositoryProvider.of<TasksetRepository>(context)
                  .reloadTasksetLoader();
            }
            if (state is TasksetOptionsPushFailed) {
              BlocProvider.of<CheckScreenBloc>(context)
                  .add(DisplaySetupError(state.error, "Aufgaben"));
            }
          },
        ),
      ],
      child: BlocBuilder<CheckScreenBloc, CheckScreenState?>(
        builder: (context, state) {
          return ScrollConfiguration(
            behavior: MyCustomScrollBehavior(),
            child: Scaffold(
              body: Column(
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
                        Flexible(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.jumpToPage(1);
                            },
                            child: Icon(Icons.home),
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(0)),
                          ),
                        ),
                        Flexible(
                          flex: 14,
                          child: SmoothPageIndicator(
                            controller: controller,
                            count: pages.length,
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () {
                              if (controller.page == pages.length - 1) {
                                BlocProvider.of<CheckScreenBloc>(context)
                                  ..add(CreateAdminEvent(context));
                              } else {
                                controller.nextPage(
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeIn);
                              }
                            },
                            child: Icon(Icons.navigate_next),
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(0)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  ///uses [PageViewerModel] to model each page in the welcome_screen
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
        description:
            "Du weißt bereits wie die App funktioniert? Dann benutze die unten "
            "angezeigten Navigationstasten, um schnell einzusteigen. ",
        image: Image.asset("assets/images/png/no_login_home.png"),
        button: ElevatedButton(
          onPressed: () {
            controller.jumpToPage(2);
          },
          child: Text("Zur Gastseite",
              style: LamaTextTheme.getStyle(fontSize: 15)),
        ),
        widget: ElevatedButton(
          onPressed: () {
            controller.jumpToPage(3);
          },
          child: Text(
            "Zur Adminseite",
            style: LamaTextTheme.getStyle(fontSize: 15),
          ),
        ),
        widget2: ElevatedButton(
          onPressed: () {
            controller.jumpToPage(4);
          },
          child: Text(
            "Zur Setupseite",
            style: LamaTextTheme.getStyle(fontSize: 15),
          ),
        ),
      ),
      PageViewerModel(
          title: "Spring einfach rein!",
          description: "Du möchtest als Gast weiter und einfach die "
              "Standardaufgaben ausprobieren? Einen Admin kann man später "
              "immernoch anlegen.",
          image: Image.asset('assets/images/png/features.png'),
          button: ElevatedButton(
            onPressed: () {
              context.read<CheckScreenBloc>().add(CreateGuestEvent(context));
            },
            child: Text("Weiter als Gast",
                style: LamaTextTheme.getStyle(fontSize: 15)),
          )),
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
              context.read<CheckScreenBloc>().add(CreateAdminEvent(context));
            },
            child: Text("Weiter als Admin",
                style: LamaTextTheme.getStyle(fontSize: 15)),
          )),
      PageViewerModel(
          title: "Dein Lehrer hat dir einen Link gegeben?",
          description:
              "Kopiere den Link und füge ihn einfach hier ein, es wird "
              "alles für dich eingestellt und du kannst loslegen.",
          image: Image.asset('assets/images/png/setup_login.png'),
          widget: TextFormField(
            initialValue: null,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: 'Setup URL',
              hintText: 'https://beispiel.de/setup.json',
            ),
            onChanged: (value) =>
                {context.read<CheckScreenBloc>().add(SetupChangeUrl(value))},
            /* validator: (value) => InputValidation.inputURLValidation(value), */
            onFieldSubmitted: (value) => {
              /* if (_formKey.currentState!.validate()) */
              context.read<CheckScreenBloc>().add(InsertSetupEvent(context))
            },
          )),
      PageViewerModel(
        title: "Alles Verstanden? Los geht's!",
        description:
            "Wende dich bei Fragen an unser github und lese dir die dort "
            "verfügbaren PDF-Dateien durch! Wir wünschen dir viel Spaß mit der "
            "App!",
        image: Image.asset("assets/images/png/plane-1598084_1280.png"),
      )
    ];
  }

  ///provides skeleton vor a page in the welcome screen
  Widget PageViewerModel(
      {String? title,
      String? description,
      var image,
      ElevatedButton? button,
      Widget? widget,
      Widget? widget2}) {
    return Column(
      children: [
        Flexible(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Center(
                child: image,
              ),
            )),
        Flexible(
            flex: 3,
            child: Column(children: [
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  title!,
                  style: LamaTextTheme.getStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  description!,
                  style: LamaTextTheme.getStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
                child: button,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 5),
                child: widget,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: widget2,
              ),
            ])),
      ],
    );
  }

  ///(private)
  ///provides [AlertDialog] to show error message
  ///
  ///{@param} error message as String
  Widget _insertErrorPopUp(String error, String errorType) {
    return AlertDialog(
      title: Text(
        'Fehler beim laden der $errorType',
        style: LamaTextTheme.getStyle(
          color: LamaColors.black,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Text(
          error,
          style: LamaTextTheme.getStyle(
            color: LamaColors.black,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            monospace: true,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      actions: [
        TextButton(
          child: Text('Schließen'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

///used to make welcome screen useable with a mouse
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}
