import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_choose_task/taskset_choose_task_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_creation_card/widgets/taskset_creation_cart_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/widgets/custom_appbar.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/input_validation.dart';
import 'package:lama_app/app/bloc/taskset_options_bloc.dart';

import '../../../../bloc/create_taskset_bloc.dart';

///This file creates the Taskset Creation Cart Screen
///This Screen provides an option to add a task to the current taskset
///or to generate a JSON from it.
///
///
///{@important} the url given via input should be validated with the
///[InputValidation] to prevent any Issue with Exceptions. However
///in this screen the [InputValidation] is only used to prevent simple issues.
///The connection erros are handelt through the [TasksetOptionsBloc]
///
/// * see also
///    [TasksetCreationCartBloc]
///    [TasksetCreationCartEvent]
///    [TasksetCreationState]
///
/// Author: Handito Bismo, Nico Soethe
/// latest Changes: 09.06.2022
class TasksetCreationCartScreen extends StatelessWidget {
  const TasksetCreationCartScreen() : super();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Taskset taskset = BlocProvider.of<CreateTasksetBloc>(context).taskset;
    return Scaffold(
      appBar: CustomAppbar(
        titel: taskset.name,
        size: screenSize.width/5,
        color: LamaColors.findSubjectColor(taskset.subject), //TODO: BLOC
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(5),
              child: ListView.builder(
                itemBuilder: (context, index) =>
                    TasksetCreationCartWidget(index: index),
                itemCount: taskset.tasks.length,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<CreateTasksetBloc>(context),
                        child: TasksetChooseTaskScreen(),
                        )
                    ),
                  ),
                  child: const Text("Task hinzufügen"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<CreateTasksetBloc>(context),
                        child: TasksetChooseTaskScreen(),
                        )
                    ),
                  ),
                  child: const Text("Taskset generieren"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
