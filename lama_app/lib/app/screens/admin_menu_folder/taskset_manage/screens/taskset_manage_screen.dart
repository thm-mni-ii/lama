import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/taskset_creation_bloc.dart';
import 'package:lama_app/app/repository/taskset_repository.dart';
import 'package:lama_app/app/screens/admin_menu_folder/custom_appbar.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/widgets/taskset_expansion_tile_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_creation_screen.dart';
// blocs

//Lama default
import 'package:lama_app/util/LamaColors.dart';

import '../../../../bloc/taskset_options_bloc.dart';
import '../../../taskset_option_screen.dart';

/// Author: N. Soethe
/// latest Changes: 09.06.2022

class TasksetManageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TasksetRepository tasksetRepository =
        RepositoryProvider.of<TasksetRepository>(context);
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppbar(
        size: screenSize.width / 5,
        titel: "Meine erstellten Tasks",
        color: LamaColors.bluePrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                for (int i = 1; i <= 6; i++)
                  TasksetExpansionTileWidget(
                    classString: 'Klasse $i',
                    listOfTasksets: tasksetRepository.getTasksetsForGrade(i),
                  ),
/*                   TasksetExpansionTileWidget(
                    classString: 'Klasse 2',
                    listOfTasksets: tasksetRepository.getTasksetsForGrade(2),
                  ),
                  TasksetExpansionTileWidget(
                    classString: 'Klasse 3',
                    listOfTasksets: tasksetRepository.getTasksetsForGrade(3),
                  ),
                  TasksetExpansionTileWidget(
                    classString: 'Klasse 4',
                    listOfTasksets: tasksetRepository.getTasksetsForGrade(4),
                  ),
                  TasksetExpansionTileWidget(
                    classString: 'Klasse 5',
                    listOfTasksets: tasksetRepository.getTasksetsForGrade(5),
                  ),
                  TasksetExpansionTileWidget(
                    classString: 'Klasse 6',
                    listOfTasksets: tasksetRepository.getTasksetsForGrade(6),
                  ),
 */
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(LamaColors.bluePrimary),
                  ),
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
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Taskset erstellen",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                TextButton(
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Taskset importieren",
                      style: TextStyle(color: LamaColors.bluePrimary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
