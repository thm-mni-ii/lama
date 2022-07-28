import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/event/create_taskset_event.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/headline_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/widgets/custom_appbar.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/key_generator.dart';

import '../widgets/lamacoin_input_widget.dart';
import '../widgets/numbers_input_widget.dart';

class CreateNumberlineScreen extends StatefulWidget {
  final TaskNumberLine? task;

  const CreateNumberlineScreen({Key? key, required this.task})
      : super(key: key);
  @override
  CreateNumberlineScreenState createState() => CreateNumberlineScreenState();
}

class CreateNumberlineScreenState extends State<CreateNumberlineScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _vonController = TextEditingController();
  TextEditingController _bisController = TextEditingController();
  TextEditingController _rewardController = TextEditingController();
  TextEditingController _stepsController = TextEditingController();

  bool newTask = true;

  bool? randomRangeAllowed = false;
  bool? ontapAllowed = false;

  @override
  Widget build(BuildContext context) {
    Taskset blocTaskset = BlocProvider.of<CreateTasksetBloc>(context).taskset!;
    Size screenSize = MediaQuery.of(context).size;

    if (widget.task != null && newTask) {
      _vonController.text = widget.task!.range.elementAt(0).toString();
      _bisController.text = widget.task!.range.elementAt(1).toString();
      _rewardController.text = widget.task!.reward.toString();
      _stepsController.text = widget.task!.steps.toString();

      newTask = false;
    }

    return Scaffold(
        appBar: CustomAppbar(
          size: screenSize.width / 5,
          titel: "Numberline",
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
                      HeadLineWidget("Zahlenbereich"),
                      Container(
                        margin:
                            EdgeInsets.only(left: 15, bottom: 15, right: 30),
                        child: Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(right: 30),
                                  child: TextFormField(
                                    controller: _vonController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Von',
                                    ),
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return "Beitrag fehlt!";
                                      } else if (double.parse(
                                              _vonController.text) <=
                                          double.parse(text)) {
                                        return "Zu groß";
                                      }
                                      return null;
                                    },
                                    onSaved: (text) =>
                                        _vonController.text = text!,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 30),
                                  child: Text(
                                    "bis",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 30),
                                  child: TextFormField(
                                    controller: _bisController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Bis',
                                    ),
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return "Beitrag fehlt!";
                                      } else if (double.parse(text) <=
                                          double.parse(_bisController.text)) {
                                        return "Zu klein";
                                      }
                                      return null;
                                    },
                                    onSaved: (text) {
                                      _bisController.text = text!;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            HeadLineWidget("Weitere Optionen"),
                            CheckboxListTile(
                              title: Text("Zufällige Range"),
                              value: randomRangeAllowed,
                              onChanged: (bool? value) {
                                setState(() {
                                  randomRangeAllowed = value;
                                });
                              },
                            ),
                            CheckboxListTile(
                              title: Text("On Tap"),
                              value: ontapAllowed,
                              onChanged: (bool? value) {
                                setState(() {
                                  ontapAllowed = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      HeadLineWidget("Schritte"),
                      NumberInputWidget(
                        numberController: _stepsController,
                        labelText: "Gib die Schritte ein",
                        missingInput: "Angabe fehlt",
                      ),
                      HeadLineWidget("Erreichbare Lamacoins"),
                      LamacoinInputWidget(
                        numberController: _rewardController,
                      )
                    ],
                  ),
                ),
              ),
            )),
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
                List<int> list = [
                  int.parse(_vonController.text),
                  int.parse(_bisController.text)
                ];
                TaskNumberLine taskNumberLine = TaskNumberLine(
                    widget.task?.id ??
                        KeyGenerator.generateRandomUniqueKey(
                            blocTaskset.tasks!),
                    TaskType.numberLine,
                    int.parse(_rewardController.text),
                    "Gib den im Zahlenstrahl rot markierten Wert an!",
                    3,
                    list,
                    randomRangeAllowed!,
                    int.parse(_stepsController.text),
                    ontapAllowed!);
                if (newTask) {
                  // add Task
                  BlocProvider.of<CreateTasksetBloc>(context)
                      .add(AddTask(taskNumberLine));
                  Navigator.pop(context);
                } else {
                  // edit Task
                  BlocProvider.of<CreateTasksetBloc>(context)
                      .add(EditTask(taskNumberLine));
                }
                Navigator.pop(context);
              }
            },
            child: Text(newTask ? "Task hinzufügen" : "verändere Task"),
          ),
        ));
  }
}
