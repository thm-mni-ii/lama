import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_creation_screen.dart';
// blocs


//Lama default
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

import '../../bloc/taskset_options_bloc.dart';
import '../taskset_option_screen.dart';


/// Author: N. Soethe
/// latest Changes: 01.06.2022

class TasksetManageScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TasksetManageScreenState();
}

class TasksetManageScreenState extends State<TasksetManageScreen> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: _bar(screenSize.width / 5, "Aufgabenverwaltung", LamaColors.bluePrimary),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.all(25),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (BuildContext context) => CreateTasksetBloc(),
                          child: TasksetCreationScreen(),
                        )
                    ));
                  },
                  child: const Text("Taskset erstellen"),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                margin: EdgeInsets.all(25),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => BlocProvider(
                        create: (BuildContext context) => TasksetOptionsBloc(),
                        child: OptionTaskScreen(),
                        )
                    ));
                  },
                  child: const Text("Taskset importieren"),
                ),
              ),
            )
          ],
        ),
    );
  }

  Widget _bar(double size, String titel, Color colors) {
    return AppBar(
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