import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/bloc/taskset_create_tasklist_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/custom_bottomNavigationBar_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/dropdown_widget_String.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/headline_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/lamacoin_input_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/widgets/custom_appbar.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/key_generator.dart';

class CreateClockTask extends StatefulWidget {
  final int? index;
  final ClockTest? task;
  const CreateClockTask({Key? key, required this.index, required this.task})
      : super(key: key);

  @override
  State<CreateClockTask> createState() => _CreateClockTaskState();
}

class _CreateClockTaskState extends State<CreateClockTask> {
  bool _isTimer = true;
  bool newTask = true;
  TextEditingController _rewardController = TextEditingController();
  String? _currentSelectedHour;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> options = [
    "vollStunde",
    "halbeStunde",
    "viertelStunde",
    "allStunden",
  ];

  @override
  Widget build(BuildContext context) {
    CreateTasksetBloc bloc = BlocProvider.of<CreateTasksetBloc>(context);
    Taskset blocTaskset = bloc.taskset!;
    Size screenSize = MediaQuery.of(context).size;

    if (widget.task != null && newTask) {
      _rewardController.text = widget.task!.reward.toString();
      _currentSelectedHour = widget.task!.uhr.toString();
      _isTimer = widget.task!.timer!;

      newTask = false;
    }
    return Scaffold(
      appBar: CustomAppbar(
        size: screenSize.width / 5,
        titel: "Clock Task",
        color: LamaColors.findSubjectColor(blocTaskset.subject ?? "normal"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Read Clock"),
                  Switch.adaptive(
                    value: _isTimer,
                    onChanged: (bool value) => setState(() => _isTimer = value),
                  ),
                  const Text("Set Clock"),
                ],
              ),
            ),
            DropdownWidgetString(
              hintText: "Stundenanzeige",
              currentSelected: _currentSelectedHour,
              itemsList: options,
              onChanged: (String? newValue) {
                setState(() => _currentSelectedHour = newValue);
              },
            ),
            HeadLineWidget("Erreichbare Lamacoins"),
            LamacoinInputWidget(
              numberController: _rewardController,
            )
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        color: LamaColors.findSubjectColor(blocTaskset.subject ?? "normal"),
        newTask: newTask,
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            //List<int> list = [int.parse(_vonController.text), int.parse(_bisController.text)];
            ClockTest clockTest = ClockTest(
                widget.task?.id ??
                    KeyGenerator.generateRandomUniqueKey(blocTaskset.tasks!),
                TaskType.clock,
                int.parse(_rewardController.text),
                "Wie viel Uhr ist es?",
                3,
                _currentSelectedHour,
                _isTimer,
                "", //todo right/wrong Answer
                "");
            if (newTask) {
              // add Task
              BlocProvider.of<TasksetCreateTasklistBloc>(context)
                  .add(AddToTaskList(clockTest));
              Navigator.pop(context);
            } else {
              // edit Task
              BlocProvider.of<TasksetCreateTasklistBloc>(context)
                  .add(EditTaskInTaskList(widget.index, clockTest));
            }
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
