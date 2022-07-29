import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/bloc/taskset_create_tasklist_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/headline_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/text_input_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/widgets/custom_appbar.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/key_generator.dart';

import '../widgets/lamacoin_input_widget.dart';

class CreateClockScreen extends StatefulWidget {
  final int? index;
  final ClockTest? task;

  const CreateClockScreen({Key? key, required this.index, required this.task}) : super(key: key);
  @override
  CreateClockScreenState createState() => CreateClockScreenState();
}

class CreateClockScreenState extends State<CreateClockScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _rewardController = TextEditingController();
  TextEditingController _uhrController = TextEditingController();

  bool? timerAllowed = false;
  bool newTask = true;

  @override
  Widget build(BuildContext context) {
    Taskset blocTaskset = BlocProvider.of<CreateTasksetBloc>(context).taskset!;
    Size screenSize = MediaQuery.of(context).size;

    if (widget.task != null && newTask) {
      //_vonController.text = widget.task!.range.elementAt(0).toString();
      //_bisController.text = widget.task!.range.elementAt(1).toString();
      _rewardController.text = widget.task!.reward.toString();
      _uhrController.text = widget.task!.reward.toString();

      //_stepsController.text = widget.task!.steps.toString();
      //_optimumController.text = widget.task!.optimum.toString();

      newTask = false;
    }

    return Scaffold(
        appBar: CustomAppbar(
          size: screenSize.width / 5,
          titel: "Clock",
          color: LamaColors.findSubjectColor(blocTaskset.subject ?? "normal"),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.all(5),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        HeadLineWidget("Uhr"),
                        TextInputWidget(
                            textController: _uhrController,
                            missingInput: "Angabe fehlt",
                            labelText: "Uhr angeben"),
                        Container(
                          child: Column(
                            children: [
                              HeadLineWidget("Weitere Optionen"),
                              CheckboxListTile(
                                title: Text("Timer allowed"),
                                value: timerAllowed,
                                onChanged: (bool? value) {
                                  setState(() {
                                    timerAllowed = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        HeadLineWidget("Erreichbare Lamacoins"),
                        LamacoinInputWidget(
                          numberController: _rewardController,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: LamaColors.findSubjectColor(
                    blocTaskset.subject ?? "normal")),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                //List<int> list = [int.parse(_vonController.text), int.parse(_bisController.text)];
                ClockTest clockTest = ClockTest(
                    widget.task?.id ??
                        KeyGenerator.generateRandomUniqueKey(
                            blocTaskset.tasks!),
                    TaskType.clock,
                    int.parse(_rewardController.text),
                    "Wie viel Uhr ist es?",
                    3,
                    _uhrController.text,
                    timerAllowed,
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
            child: Text(newTask ? "Task hinzufügen" : "verändere Task"),
          ),
        ));
  }
}
