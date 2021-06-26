import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/admin_menu_bloc.dart';
import 'package:lama_app/app/bloc/taskset_options_bloc.dart';
import 'package:lama_app/app/bloc/user_management_bloc.dart';
import 'package:lama_app/app/bloc/user_selection_bloc.dart';
import 'package:lama_app/app/bloc/userlist_url_bloc.dart';
import 'package:lama_app/app/event/admin_menu_event.dart';
import 'package:lama_app/app/repository/taskset_repository.dart';
import 'package:lama_app/app/screens/taskset_option_screen.dart';
import 'package:lama_app/app/screens/user_management_screen.dart';
import 'package:lama_app/app/screens/user_selection_screen.dart';
import 'package:lama_app/app/screens/userlist_url_screen.dart';
import 'package:lama_app/app/state/admin_menu_state.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

class AdminMenuScreen extends StatefulWidget {
  @override
  _AdminMenuScreenState createState() => _AdminMenuScreenState();
}

class _AdminMenuScreenState extends State<AdminMenuScreen> {
  bool _isChecked = true;

  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size;
    return BlocBuilder<AdminMenuBloc, AdminMenuState>(
      builder: (context, state) {
        if (state is AdminMenuPrefLoadedState) {
          _isChecked = state.prefDefaultTasksEnable;
          context.read<AdminMenuBloc>().add(AdminMenuLoadDefaultEvent());
          return Center(child: CircularProgressIndicator());
        }
        if (state is AdminMenuDefaultState) {
          return Scaffold(
            appBar:
                _bar(screensize.width / 5, 'Adminmenü', LamaColors.bluePrimary),
            body: _buttonColumne(context),
          );
        }
        context.read<AdminMenuBloc>().add(AdminMenuLoadPrefsEvent());
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buttonColumne(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(50),
      child: Wrap(
        runSpacing: 5,
        children: [
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
          _checkBox(context),
        ],
      ),
    );
  }

  Widget _checkBox(BuildContext context) {
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

abstract class AdminUtils {
  static final String enableDefaultTasksetsPref = 'enableDefaultTaskset';

  static void reloadTasksets(BuildContext context) {
    RepositoryProvider.of<TasksetRepository>(context).reloadTasksetLoader();
  }

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
}
