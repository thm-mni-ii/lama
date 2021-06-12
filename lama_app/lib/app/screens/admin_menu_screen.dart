import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/taskset_options_bloc.dart';
import 'package:lama_app/app/bloc/user_management_bloc.dart';
import 'package:lama_app/app/screens/taskset_option_screen.dart';
import 'package:lama_app/app/screens/user_management_screen.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

class AdminMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _bar(screensize.width / 5, 'Adminmenü', LamaColors.bluePrimary),
      body: _buttonColumne(context),
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
            Icon(Icons.add_link),
            'Aufgabenverwalten',
            () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (BuildContext context) => TasksetOprionsBloc(),
                    child: OptionTaskScreen(),
                  ),
                ),
              )
            },
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
              Navigator.pop(
                context,
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
