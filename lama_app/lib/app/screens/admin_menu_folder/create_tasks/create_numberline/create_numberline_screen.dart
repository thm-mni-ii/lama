import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/event/create_taskset_event.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_choose_task/screens/taskset_choose_task_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/widgets/custom_appbar.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/key_generator.dart';

class CreateNumberlineScreen extends StatefulWidget {
  final TaskNumberLine? task;

  const CreateNumberlineScreen({Key? key, required this.task}) : super(key: key);
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
      //_optimumController.text = widget.task!.optimum.toString();

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
                        "Zahlen Range",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, bottom: 15, right: 30),
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
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            " RandomRange und Ontap allowed",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        CheckboxListTile(
                          title: Text("randomRange"),
                          value: randomRangeAllowed,
                          onChanged: (bool? value) {
                            setState(() {
                              randomRangeAllowed = value;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text("ontap"),
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
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Steps",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                    child: TextFormField(
                      controller: _stepsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Steps',
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return "Beitrag fehlt!";
                        }
                        return null;
                      },
                      onSaved: (String? text) =>
                      _stepsController.text = text!,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 5, right: 5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Erreichbare Lamacoins",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                    child: TextFormField(
                      controller: _rewardController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Erreichbare Lamacoins',
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
          )
          ),
          Container(
            margin: EdgeInsets.only(bottom: 25),
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
                      ),
                    ),
                  ),
                  child: const Text("Preview"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      List<int> list = [int.parse(_vonController.text), int.parse(_bisController.text)];
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
                          ontapAllowed!
                      );
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
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
