import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/bloc/taskset_create_tasklist_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/widgets/custom_appbar.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/key_generator.dart';

class CreateClockTask extends StatefulWidget {
  final int index;
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
    TasksetCreateTasklistBloc blocTaskList =
        BlocProvider.of<TasksetCreateTasklistBloc>(context);
    CreateTasksetBloc bloc = BlocProvider.of<CreateTasksetBloc>(context);
    Taskset blocTaskset = bloc.taskset!;
    Size screenSize = MediaQuery.of(context).size;

    if (widget.task != null && newTask) {
      _rewardController.text = widget.task!.reward.toString();
      _currentSelectedHour = widget.task!.uhr;
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
              margin: const EdgeInsets.all(5),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                hint: Text("Stunden Anzeige"),
                value: _currentSelectedHour,
                isDense: true,
                onChanged: (String? newValue) {
                  setState(() => _currentSelectedHour = newValue);
                },
                items: options.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: _rewardController,
                decoration: InputDecoration(hintText: "Rewards"),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return "Beitrag fehlt!";
                  } else if (int.parse(text) <= 0) return "Zu klein";
                  return null;
                },
                onSaved: (text) => _rewardController.text = text!,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {},
              child: const Text("Preview"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ClockTest clockTask = ClockTest(
                    widget.task?.id ??
                        KeyGenerator.generateRandomUniqueKey(
                          blocTaskset.tasks!,
                        ),
                    TaskType.clock,
                    int.parse(_rewardController.text),
                    "Wie viel Uhr ist es?",
                    3,
                    _currentSelectedHour,
                    _isTimer,
                    "",
                    "",
                  );
                  if (newTask) {
                    // add Task
                    blocTaskList.add(AddToTaskList(clockTask));
                    Navigator.pop(context);
                  } else {
                    // edit Task
                    blocTaskList.add(
                      EditTaskInTaskList(widget.index, clockTask),
                    );
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(newTask ? "Task hinzufügen" : "verändere Task"),
            )
          ],
        ),
      ),
    );
  }
}
