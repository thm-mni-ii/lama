import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/event/create_taskset_event.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_choose_task/screens/taskset_choose_task_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/widgets/custom_appbar.dart';
import 'package:lama_app/app/screens/task_type_screens/clock_task_screen.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/key_generator.dart';

class CreateClockScreen extends StatefulWidget {
  final ClockTest? task;

  const CreateClockScreen({Key? key, required this.task}) : super(key: key);
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
          Expanded(child: Container(
            margin: EdgeInsets.all(5),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 25),
                    child: Container(
                      margin: EdgeInsets.only(left: 5, bottom: 15, right: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Uhr",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, bottom: 15, right: 30),
                    child: TextFormField(
                      controller: _uhrController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Uhr wortwörtlich',
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return "Beitrag fehlt!";
                        }
                        return null;
                      },
                      onSaved: (String? text) =>
                      _uhrController.text = text!,
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 30, left: 5, right: 5),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Timer",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child: Container(
                      margin: EdgeInsets.only(left: 5, bottom: 15, right: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Reward",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, bottom: 15, right: 30),
                    child: TextFormField(
                      controller: _rewardController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'erreichbares Reward',
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return "Beitrag fehlt!";
                        }
                        return null;
                      },
                      onSaved: (String? text) =>
                      _rewardController.text = text!,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      //List<int> list = [int.parse(_vonController.text), int.parse(_bisController.text)];
                      ClockTest clockTest  = ClockTest(
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
                        ""
                      );
                      if (newTask) {
                        // add Task
                        BlocProvider.of<CreateTasksetBloc>(context)
                            .add(AddTask(clockTest));
                        Navigator.pop(context);
                      } else {
                        // edit Task
                        BlocProvider.of<CreateTasksetBloc>(context)
                            .add(EditTask(clockTest));
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: Text(newTask ? "Task hinzufügen" : "verändere Task"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
