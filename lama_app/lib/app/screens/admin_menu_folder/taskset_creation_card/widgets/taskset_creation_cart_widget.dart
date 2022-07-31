import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/event/create_taskset_event.dart';
import 'package:lama_app/app/screens/admin_menu_folder/bloc/taskset_create_tasklist_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/create_buchstabieren/create_buchstabieren_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/create_clock/create_clock_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/create_clozetest/create_clozeTest_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/create_connect/create_connect_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/create_equation/create_equation_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/create_gridselect/create_gridselect_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/create_markwords/create_markwords_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/create_matchcategory/create_matchcategory_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/create_moneytask/create_moneytask_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/create_four_cards/create_four_cards_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/create_numberline/create_numberline_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/create_vocabletest/create_vocabletest_screen.dart';
import 'package:lama_app/app/task-system/task.dart';

///This file creates the Taskset Creation Cart Widget
///This Widget provides a Card for a Task
///
///
///
/// * see also
///    [TasksetCreationCartBloc]
///    [TasksetCreationCartEvent]
///    [TasksetCreationState]
///
/// Author: Tim Steinmüller
/// latest Changes: 09.06.2022
class TasksetCreationCartWidget extends StatelessWidget {
  final Task task;
  final int index;
  const TasksetCreationCartWidget({
    Key? key,
    required this.task,
    required this.index,
  }) : super(key: key);

  Widget screenDependingOnTaskType(TaskType taskType) {
    switch (taskType) {
      case TaskType.moneyTask:
        return MoneyEinstellenScreen(index: index, task: task as TaskMoney);
      case TaskType.fourCards:
        return CreateFourCardsScreen(index: index, task: task as Task4Cards);
      case TaskType.equation:
        return CreateEquationScreen(index: index, task: task as TaskEquation);
      case TaskType.vocableTest:
        return CreateVocabletestScreen(
            index: index, task: task as TaskVocableTest);
      case TaskType.numberLine:
        return CreateNumberlineScreen(
            index: index, task: task as TaskNumberLine);
      case TaskType.matchCategory:
        return CreateMatchCategoryScreen(
            index: index, task: task as TaskMatchCategory);
      case TaskType.markWords:
        return CreateMarkWordsScreen(index: index, task: task as TaskMarkWords);
      case TaskType.gridSelect:
        return CreateGridSelectScreen(
            index: index, task: task as TaskGridSelect);
      case TaskType.clozeTest:
        return CreateClozeTestScreen(index: index, task: task as TaskClozeTest);
      case TaskType.clock:
        return CreateClockScreen(index: index, task: task as ClockTest);
      case TaskType.buchstabieren:
        return CreateBuchstabierenScreen(
            index: index, task: task as TaskBuchstabieren);
      case TaskType.connect:
        return CreateConnectScreen(
            index: index, task: task as TaskConnect);
      default:
        return Placeholder();
    }
  }

  @override
  Widget build(BuildContext context) {
    final createTasklistBloc = BlocProvider.of<TasksetCreateTasklistBloc>(context);
    return Card(
      elevation: 5,
      child: Dismissible(
        key: Key(task.id),
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (DismissDirection dismissDirection) {
          createTasklistBloc.add(RemoveFromTaskList(task.id));
        },
        child: ListTile(
          title: Text(
            task.type.toString().toUpperCase().substring(9),
          ),
          subtitle: Text(task.lamaText),
          trailing: SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value: BlocProvider.of<CreateTasksetBloc>(context),
                          ),
                          BlocProvider.value(
                            value: createTasklistBloc,
                          ),
                        ],
                        child: screenDependingOnTaskType(task.type),
                      ),
                    ),
                  ),
                  icon: Icon(Icons.edit),
                  color: Colors.black,
                ),
                IconButton(
                  onPressed: () {
                    createTasklistBloc.add(RemoveFromTaskList(task.id));
                  },
                  icon: Icon(Icons.delete),
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
