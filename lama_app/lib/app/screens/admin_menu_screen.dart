import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/db/database_provider.dart';
//Lama default
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
//Blocs
import 'package:lama_app/app/bloc/admin_menu_bloc.dart';
import 'package:lama_app/app/bloc/taskset_options_bloc.dart';
import 'package:lama_app/app/bloc/user_management_bloc.dart';
import 'package:lama_app/app/bloc/user_selection_bloc.dart';
import 'package:lama_app/app/bloc/userlist_url_bloc.dart';
import 'package:lama_app/app/repository/taskset_repository.dart';
import 'package:lama_app/app/bloc/highscoreUrl_screen_bloc.dart';
//Events
import 'package:lama_app/app/event/admin_menu_event.dart';
//States
import 'package:lama_app/app/state/admin_menu_state.dart';
//Screens
import 'package:lama_app/app/screens/taskset_option_screen.dart';
import 'package:lama_app/app/screens/user_management_screen.dart';
import 'package:lama_app/app/screens/user_selection_screen.dart';
import 'package:lama_app/app/screens/userlist_url_screen.dart';
import 'highscoreUrl_options_screen.dart';

///This file creates the Admin Menu Screen
///The Admin Menu Screen provides every navigation to screens
///or option which coulde be used by the Admin to
///change, configur, delete or add content and users.
///
/// * see also
///    [AdminMenuBloc]
///    [AdminMenuEvent]
///    [AdminMenuState]
///
/// Author: L.Kammerer
/// latest Changes: 10.09.2021
class AdminMenuScreen extends StatefulWidget {
  @override
  _AdminMenuScreenState createState() => _AdminMenuScreenState();
}

///_AdminMenuScreenState provides the state for the [AdminMenuScreen]
class _AdminMenuScreenState extends State<AdminMenuScreen> {
  //save the Checkbox (Standardaufgaben aktivieren?) value as bool
  bool _isChecked = true;

  ///override build methode [StatelessWidget]
  ///
  ///{@param} [BuildContext] as context
  ///
  ///{@return} a [Widget] decided by the incoming state of the [AdminMenuBloc]
  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _bar(screensize.width / 5, 'Adminmenü', LamaColors.bluePrimary),
      body: BlocListener(
        bloc: BlocProvider.of<AdminMenuBloc>(context),
        listener: (context, state) {
          //shows the GitHub repository link
          if (state is AdminMenuGitHubPopUpState) {
            showDialog(context: context, builder: (_) => _gitHubAlert());
          }
        },
        child: BlocBuilder<AdminMenuBloc, AdminMenuState>(
          builder: (context, state) {
            ///Set the [_isChecked] for the [Checkbox] to ensure it's the current value of [SharedPreferences]
            ///then force the [AdminMenuLoadDefaultEvent] to move on
            if (state is AdminMenuPrefLoadedState) {
              _isChecked = state.prefDefaultTasksEnable;
              context.read<AdminMenuBloc>().add(AdminMenuLoadDefaultEvent());
              return Center(child: CircularProgressIndicator());
            }
            if (state is AdminMenuDefaultState) {
              return _buttonColumne(context);
            }

            ///Force the [AdminMenuLoadPrefsEvent] to get the current value of the [SharedPreferences]
            context.read<AdminMenuBloc>().add(AdminMenuLoadPrefsEvent());
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: LamaColors.white,
        child: SvgPicture.asset(
          'assets/images/svg/GitHub.svg',
          semanticsLabel: 'LAMA',
        ),
        onPressed: () =>
            context.read<AdminMenuBloc>().add(AdminMenuGitHubPopUpEvent()),
      ),
    );
  }

  ///(private)
  ///provides [Columne] of all Buttons or elements
  ///
  ///To add more Buttons which navigates to another
  ///Screen use [_menuButton] for an Button with
  ///[AdminMenuScreen] specific default design.
  ///
  ///{@param} [BuildContext] as context
  ///
  ///{@return} [Columne] with all Buttons or elements
  ///which could be used to navigate to another Screen or
  ///configur the App directly.
  Widget _buttonColumne(BuildContext context) {
    List<User> userList = [];
    return Padding(
      padding: EdgeInsets.all(50),
      child: Wrap(
        runSpacing: 5,
        children: [
          //Navigation Button to 'Nutzerverwaltung' [UserManagementScreen]
          _menuButton(
            context,
            Icon(Icons.group_add),
            'Nutzerverwaltung',
            () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (BuildContext context) => UserManagementBloc(),
                    child: UserManagementScreen(),
                  ),
                ),
              )
            },
          ),
          //Navigation Button to 'Nutzerliste einfügen' [UserlistUrlScreen]
          _menuButton(
            context,
            Icon(Icons.assignment_ind_sharp),
            'Nutzerliste einfügen',
            () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (BuildContext context) => UserlistUrlBloc(),
                    child: UserlistUrlScreen(),
                  ),
                ),
              )
            },
          ),
          //Navigation Button to 'Aufgabenverwaltung' [OptionTaskScreen]
          _menuButton(
            context,
            Icon(Icons.add_link),
            'Aufgabenverwaltung',
            () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (BuildContext context) => TasksetOptionsBloc(),
                    child: OptionTaskScreen(),
                  ),
                ),
              ).then((_) {
                AdminUtils.reloadTasksets(context);
              })
            },
          ),
          _menuButton(
            context,
            Icon(Icons.settings),
            'Highscore Einstellungen',
            () async => {
              userList = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (BuildContext context) => HighscoreUrlScreenBloc(),
                    child: HighscoreUrlOptionScreen(),
                  ),
                ),
              ),
              await DatabaseProvider.db
                  .updateAllUserHighscorePermission(userList)
            },
          ),
          //Checkbox to deaktivate the default Tasksets
          _checkBox(context),
        ],
      ),
    );
  }

  ///(private)
  ///provides custom [Checkbox] to deactivate or activate the App default Tasksets
  ///changes are made onChanged through [AdminMenuBloc] via [AdminMenuChangePrefsEvent]
  ///
  ///{@param} [BuildContext] as context
  ///
  ///{@return} [Checkbox] to deaktivate the default Tasksets
  Widget _checkBox(BuildContext context) {
    ///(local)
    ///getColor porvides [Color]s for the [Checkbox] 'Standardaufgaben aktivieren?'
    ///
    ///{@param} [Set<MaterialState>] as states
    ///
    ///{@return} [Color] to resolve the [Checkbox] colors by using App default colors [LamaColors]
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return LamaColors.blueAccent;
      }
      return LamaColors.bluePrimary;
    }

    //return [Checkbox] 'Standardaufgaben aktivieren?'
    return Center(
      child: Row(
        children: [
          Checkbox(
            checkColor: Colors.white,
            fillColor: MaterialStateProperty.resolveWith(getColor),
            value: _isChecked,
            onChanged: (bool value) {
              setState(() {
                _isChecked = value;
                context.read<AdminMenuBloc>().add(AdminMenuChangePrefsEvent(
                    AdminUtils.enableDefaultTasksetsPref,
                    _isChecked,
                    RepositoryProvider.of<TasksetRepository>(context)));
                AdminUtils.reloadTasksets(context);
              });
            },
          ),
          Text(
            'Standardaufgaben aktivieren?',
            style:
                LamaTextTheme.getStyle(fontSize: 14, color: LamaColors.black),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  ///(private)
  ///porvides [ElevatedButton] with [AdminMenuScreen] specific default design
  ///
  ///{@params}
  ///[BuildContext] as context
  ///[ElevatedButton] [Icon] as icon
  ///[ElevatedButton] titel as String
  ///Navigation [VoidCallback] as route
  ///
  ///{@return} [Color] to resolve the [Checkbox] colors by using App default colors [LamaColors]
  Widget _menuButton(
      BuildContext context, Icon icon, String text, VoidCallback route) {
    return ElevatedButton(
      child: Stack(
        children: [
          icon,
          Align(
            child: Padding(
              child: Text(
                text,
                style: LamaTextTheme.getStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              padding: EdgeInsets.only(top: 3, bottom: 3),
            ),
            alignment: Alignment.center,
          )
        ],
      ),
      onPressed: route,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(50, 45),
        primary: LamaColors.bluePrimary,
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(0)),
      ),
    );
  }

  ///(private)
  ///Alert to show the GitHub repository link with authors
  Widget _gitHubAlert() {
    return AlertDialog(
      title: Text(
        'GitHub',
        style: LamaTextTheme.getStyle(
          color: LamaColors.black,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
      content: Column(children: [
        SvgPicture.asset(
          'assets/images/svg/GitHub.svg',
          semanticsLabel: 'LAMA',
        ),
        SizedBox(height: 50),
        Text(
          "Link",
          style: LamaTextTheme.getStyle(
            color: LamaColors.black,
            fontSize: 16,
            fontWeight: FontWeight.w800,
            monospace: true,
          ),
        ),
        Text(
          "https://github.com/thm-mni-ii/lama",
          style: LamaTextTheme.getStyle(
            color: LamaColors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            monospace: true,
          ),
          textAlign: TextAlign.center,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 25),
            Text(
              "Projektleitung:",
              style: LamaTextTheme.getStyle(
                color: LamaColors.black,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                monospace: true,
              ),
              textAlign: TextAlign.left,
            ),
            Text(
              "Dario Pläschke",
              style: LamaTextTheme.getStyle(
                color: LamaColors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                monospace: true,
              ),
            ),
            SizedBox(height: 15),
            Text(
              "App:",
              style: LamaTextTheme.getStyle(
                color: LamaColors.black,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                monospace: true,
              ),
            ),
            Text(
              "Kevin Binder (Leitung)\nLars Kammerer\nFranz Leonhardt\nTobias Rentsch\nFabian Brescher",
              style: LamaTextTheme.getStyle(
                color: LamaColors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                monospace: true,
              ),
            ),
            SizedBox(height: 15),
            Text(
              "Spiele:",
              style: LamaTextTheme.getStyle(
                color: LamaColors.black,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                monospace: true,
              ),
            ),
            Text(
              "Vinzenz Branzk (Leitung)\nFlorian Silber",
              style: LamaTextTheme.getStyle(
                color: LamaColors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                monospace: true,
              ),
            ),
          ],
        ),
      ]),
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

  ///(private)
  ///porvides [AppBar] with [AdminMenuScreen] specific default design
  ///
  ///Customise the leading of the [AppBar] to provide
  ///an logout function which leads to [UserSelectionScreen] via
  ///[Navigator].pushReplacement
  ///
  ///{@params}
  ///[AppBar] size as double size
  ///[AppBar] titel as String title
  ///[AppBar] [Color] as colors
  ///
  ///{@return} [AppBar] with generel AdminMenu specific design
  Widget _bar(double size, String titel, Color colors) {
    return AppBar(
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (BuildContext context) => UserSelectionBloc(),
                    child: UserSelectionScreen(),
                  ),
                ),
              );
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ),
      title: Text(
        titel,
        style: LamaTextTheme.getStyle(fontSize: 18),
      ),
      toolbarHeight: size,
      backgroundColor: colors,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
    );
  }
}

///The AdminUtils class provides basic [Widget]s
///and functions to make the building more easy or
///prevent repetitive code in all Screens used for the Admin
///
/// Author: L.Kammerer
/// latest Changes: 18.09.2021
abstract class AdminUtils {
  ///START of Area for UserPreferences
  ///
  ///enableDefaultTasksetsPref is used to set an bool in the
  ///UserPreferences to deaktivate all default Tasksets made available by this App
  static final String enableDefaultTasksetsPref = 'enableDefaultTaskset';

  ///highscoreUploadUrl is used to set a string in the
  ///UserPreferences to upload game highscores via this url
  static final String highscoreUploadUrlPref = 'highscoreUploadUrl';

  ///
  ///END of Area for UserPreferences

  ///reloads all Tasksets (defaults and custom sets)
  ///reading the [TasksetRepository] from context
  ///and execute the [reloadTasksetLoader] function
  ///
  ///{@Important} the context of the app
  ///provides the [TasksetRepository] by default.
  ///However on use make sure the context provides the [TasksetRepository]
  ///This Method doesn't check the context so no error handling is implemented
  ///
  ///{@param} [BuildContext] as context
  ///
  /// * see also
  ///    [RepositoryProvider]
  ///    [TasksetRepository]
  static void reloadTasksets(BuildContext context) {
    RepositoryProvider.of<TasksetRepository>(context).reloadTasksetLoader();
  }

  ///porvides [AppBar] with default design for Screens used by the Admin
  ///
  ///{@params}
  ///[Size] as screenSize used to calculate the size of [AppBar]
  ///[AppBar] [Color] as colors
  ///[AppBar] titel as String title
  ///
  ///{@return} [AppBar] with generel AdminMenu specific design
  static Widget appbar(Size screenSize, Color color, String titel) {
    return AppBar(
      title: Text(
        titel,
        style: LamaTextTheme.getStyle(fontSize: 18),
      ),
      toolbarHeight: screenSize.width / 5,
      backgroundColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
    );
  }

  ///porvides [Row] with default designed abort and save [Ink] Button
  ///for all Screens used by the Admin where this buttons are needed.
  ///
  ///{@params}
  ///[VoidCallback] as functionLeft. onPressed for the 'Bestätigen' (save) Button.
  ///[VoidCallback] as functionRight. onPressed for the 'Abbrechen' (abort) Button.
  ///
  ///{@return} [Row] with two [Ink] Buttons
  //TODO Rename to abort not Aboard
  static Widget saveAboardButtons(
      VoidCallback functionLeft, VoidCallback functionRight) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: Ink(
            decoration: ShapeDecoration(
              color: LamaColors.greenPrimary,
              shape: CircleBorder(),
            ),
            padding: EdgeInsets.all(7.0),
            child: IconButton(
                icon: Icon(Icons.save, size: 28),
                color: Colors.white,
                tooltip: 'Bestätigen',
                onPressed: functionLeft),
          ),
        ),
        Ink(
          decoration: ShapeDecoration(
            color: LamaColors.redPrimary,
            shape: CircleBorder(),
          ),
          padding: EdgeInsets.all(2.0),
          child: IconButton(
              icon: Icon(Icons.close_rounded),
              color: Colors.white,
              tooltip: 'Abbrechen',
              onPressed: functionRight),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.end,
    );
  }
}
