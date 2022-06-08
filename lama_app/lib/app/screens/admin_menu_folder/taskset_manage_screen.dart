import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/taskset_creation_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/custom_appbar.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_creation_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/widgets/taskset_expansion_tile_widget.dart';
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
        appBar: CustomAppbar(
          size: screenSize.width / 5,
          titel: "Aufgabenverwaltung",
          color: LamaColors.bluePrimary,
        ) as PreferredSizeWidget,
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  TasksetExpansionTileWidget(classString: 'Klasse 1'),
                  TasksetExpansionTileWidget(classString: 'Klasse 2'),
                  TasksetExpansionTileWidget(classString: 'Klasse 3'),
                  TasksetExpansionTileWidget(classString: 'Klasse 4'),
                  TasksetExpansionTileWidget(classString: 'Klasse 5'),
                  TasksetExpansionTileWidget(classString: 'Klasse 6'),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  color: LamaColors.bluePrimary,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (BuildContext context) =>
                                TasksetCreationBloc(),
                            child: TasksetCreationScreen(),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Taskset erstellen",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (BuildContext context) =>
                              TasksetOptionsBloc(),
                          child: OptionTaskScreen(),
                        ),
                      ),
                    );
                  },
                  child: Text("Taskset importieren"),
                ),
              ],
            ),
          ],
        )
        /* Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.all(25),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (BuildContext context) => TasksetCreationBloc(),
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
        ), */
        );
  }
}
