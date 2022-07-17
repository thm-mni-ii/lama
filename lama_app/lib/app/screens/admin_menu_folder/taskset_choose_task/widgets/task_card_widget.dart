import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/repository/taskset_repository.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/create_buchstabieren/create_buchstabieren_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/create_clock/create_clock_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/create_clozetest/create_clozeTest_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/create_equation/create_equation_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/create_gridselect/create_gridselect_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/create_markwords/create_markwords_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/create_matchcategory/create_matchcategory_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/create_moneytask/create_moneytask_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/create_numberline/create_numberline_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/create_vocabletest/create_vocabletest_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/create_zerlegung/create_zerlegung_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/create_four_cards/create_four_cards_screen.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';

class TaskCardWidget extends StatelessWidget {
  final TaskType taskType;
  const TaskCardWidget({Key? key, required this.taskType}) : super(key: key);

  Widget screenDependingOnTaskType(TaskType taskType) {
    switch (taskType) {
      case TaskType.moneyTask:
        return MoneyEinstellenScreen(task: null);
      case TaskType.fourCards:
        return CreateFourCardsScreen(task: null);
      case TaskType.equation:
        return CreateEquationScreen(task: null);
      case TaskType.zerlegung:
        return CreateZerlegungScreen(task: null);
      case TaskType.vocableTest:
        return CreateVocabletestScreen(task: null);
      case TaskType.numberLine:
        return CreateNumberlineScreen(task: null);
      case TaskType.matchCategory:
        return CreateMatchCategoryScreen(task: null);
      case TaskType.markWords:
        return CreateMarkWordsScreen(task: null);
      case TaskType.gridSelect:
        return CreateGridSelectScreen(task: null);
      case TaskType.clozeTest:
        return CreateClozeTestScreen(task: null);
      case TaskType.clock:
        return CreateClockScreen(task: null);
      case TaskType.buchstabieren:
        return CreateBuchstabierenScreen(task: null);
      default:
        return Placeholder();
    }
  }

  @override
  Widget build(BuildContext context) {
    Taskset taskset = BlocProvider.of<CreateTasksetBloc>(context).taskset!;
    return Card(
      child: ListTile(
        title: Text(taskType.toString().substring(9).toUpperCase()),
        trailing: IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: BlocProvider.of<CreateTasksetBloc>(context),
                child: screenDependingOnTaskType(taskType),
              ),
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_right),
        ),
      ),
    );
  }
}
