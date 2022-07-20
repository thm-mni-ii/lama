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

class CreateEquationScreen extends StatefulWidget {
  final TaskEquation? task;

  const CreateEquationScreen({Key? key, required this.task}) : super(key: key);
  @override
  CreateEquationScreenState createState() => CreateEquationScreenState();
}

class CreateEquationScreenState extends State<CreateEquationScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _vonController = TextEditingController();
  TextEditingController _bisController = TextEditingController();
  TextEditingController _rewardController = TextEditingController();

  bool newTask = true;
  bool? plusAllowed = true;
  bool? minusAllowed = true;
  bool? multiplyAllowed = true;
  bool? divisionAllowed = true;
  bool? allowOperationReplace = true;

  String plus = '+';
  String minus = '-';
  String mal = '*';
  String division = '/';
  List<String> allowedOperations = ['+', '-', '*', '/'];

/*   @override
  void initState() {
    if (widget.task != null) {
      _vonController.text = widget.task!.von.toString();
      _bisController.text = widget.task!.bis.toString();
      _rewardController.text = widget.task!.reward.toString();
    
      newTask = false;
    }
    super.initState();
  } */

  @override
  Widget build(BuildContext context) {
    Taskset blocTaskset = BlocProvider.of<CreateTasksetBloc>(context).taskset!;
    Size screenSize = MediaQuery.of(context).size;

/*     if (widget.task != null && newTask) {
      _vonController.text = widget.task!.operandRange[0].toString();
      _bisController.text = widget.task!.operandRange[1].toString();
      _rewardController.text = widget.task!.reward.toString();

      newTask = false;
    } */

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppbar(
        size: screenSize.width / 5,
        titel: "Equation",
        color: LamaColors.findSubjectColor(blocTaskset.subject ?? "normal"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(5),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 25),
                        child: Container(
                          margin:
                              EdgeInsets.only(left: 5, bottom: 15, right: 5),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Zahlenbereich",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
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
                                              _bisController.text) <=
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
                                          double.parse(_vonController.text)) {
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
                              margin:
                                  EdgeInsets.only(top: 30, left: 5, right: 5),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Erlaubte Operationen",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            CheckboxListTile(
                              title: Text("Addition"),
                              value: plusAllowed,
                              onChanged: (bool? value) {
                                setState(() {
                                  plusAllowed = value;
                                });
                                if (value == true) {
                                  allowedOperations.add(plus);
                                } else {
                                  allowedOperations.removeWhere(
                                      (element) => element == plus);
                                }
                                print(allowedOperations);
                              },
                            ),
                            CheckboxListTile(
                              title: Text("Subraktion"),
                              value: minusAllowed,
                              onChanged: (bool? value) {
                                setState(() {
                                  minusAllowed = value;
                                });
                                if (value == true) {
                                  allowedOperations.add(minus);
                                } else {
                                  allowedOperations.removeWhere(
                                      (element) => element == minus);
                                }
                                print(allowedOperations);
                              },
                            ),
                            CheckboxListTile(
                              title: Text("Multiplikation"),
                              value: multiplyAllowed,
                              onChanged: (bool? value) {
                                setState(() {
                                  multiplyAllowed = value;
                                });
                                if (value == true) {
                                  allowedOperations.add(mal);
                                } else {
                                  allowedOperations
                                      .removeWhere((element) => element == mal);
                                }
                                print(allowedOperations);
                              },
                            ),
                            CheckboxListTile(
                              title: Text("Division"),
                              value: divisionAllowed,
                              onChanged: (bool? value) {
                                setState(() {
                                  divisionAllowed = value;
                                });
                                if (value == true) {
                                  allowedOperations.add(division);
                                } else {
                                  allowedOperations.removeWhere(
                                      (element) => element == division);
                                }
                                print(allowedOperations);
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.only(top: 30, left: 5, right: 5),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Weitere Optionen",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            CheckboxListTile(
                              title: Text("Erlaube Suche nach Rechenzeichen"),
                              value: allowOperationReplace,
                              onChanged: (bool? value) {
                                setState(() {
                                  allowOperationReplace = value;
                                });
                                print(allowedOperations);
                              },
                            ),
                          ]
                        )
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30, left: 5, right: 5),
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
                        margin: EdgeInsets.only(left: 5, right: 5),
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
                      List<int> listVonBis = [
                        int.parse(_vonController.text),
                        int.parse(_bisController.text)
                      ];
                      TaskEquation equationTask = TaskEquation(
                          widget.task?.id ??
                              KeyGenerator.generateRandomUniqueKey(
                                  blocTaskset.tasks!),
                          TaskType.equation,
                          int.parse(_rewardController.text),
                          "Löse die Gleichung!",
                          3,
                          [],
                          [],
                          allowedOperations,
                          allowOperationReplace,
                          listVonBis,
                          null,
                          -1);
                      if (newTask) {
                        // add Task
                        BlocProvider.of<CreateTasksetBloc>(context)
                            .add(AddTask(equationTask));
                        Navigator.pop(context);
                      } else {
                        // edit Task
                        BlocProvider.of<CreateTasksetBloc>(context)
                            .add(EditTask(equationTask));
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
