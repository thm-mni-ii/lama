import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/bloc/taskset_create_tasklist_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/custom_bottomNavigationBar_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/headline_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/numbers_input_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/widgets/custom_appbar.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/key_generator.dart';

import '../widgets/lamacoin_input_widget.dart';

class CreateEquationScreen extends StatefulWidget {
  final int? index;
  final TaskEquation? task;

  const CreateEquationScreen(
      {Key? key, required this.index, required this.task})
      : super(key: key);
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

  @override
  Widget build(BuildContext context) {
    Taskset blocTaskset = BlocProvider.of<CreateTasksetBloc>(context).taskset!;
    Size screenSize = MediaQuery.of(context).size;

    if (widget.task != null && newTask) {
      _vonController.text = widget.task!.operandRange[0].toString();
      _bisController.text = widget.task!.operandRange[1].toString();
      allowOperationReplace = widget.task!.allowReplacingOperators;
      _rewardController.text = widget.task!.reward.toString();

      if (!widget.task!.randomAllowedOperators.contains("+")) {
        plusAllowed = false;
        allowedOperations.removeWhere((element) => element == plus);
      }

      if (!widget.task!.randomAllowedOperators.contains("-")) {
        minusAllowed = false;
        allowedOperations.removeWhere((element) => element == minus);
      }

      if (!widget.task!.randomAllowedOperators.contains("/")) {
        divisionAllowed = false;
        allowedOperations.removeWhere((element) => element == division);
      }

      if (!widget.task!.randomAllowedOperators.contains("*")) {
        multiplyAllowed = false;
        allowedOperations.removeWhere((element) => element == mal);
      }

      newTask = false;
    }

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
                                  child: NumberInputWidget(
                                    numberController: _vonController,
                                    missingInput: "Zahl angeben",
                                    labelText: "von",
                                    validator: (text) {
                                      if (int.parse(_bisController.text) <= int.parse(text)) {
                                          return "Zu groß";
                                      }
                                    },
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
                                  child: NumberInputWidget(
                                    numberController: _bisController, 
                                    missingInput: "Zahl angeben", 
                                    labelText: "bis",
                                    validator: (text) {
                                      if (int.parse(text) <= int.parse(_vonController.text)) {
                                          return "Zu klein";
                                      }
                                    },
                                  )
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              HeadLineWidget("Erlaubte Operationen"),
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
                                    allowedOperations.removeWhere(
                                        (element) => element == mal);
                                  }
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
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                            child: Column(children: [
                          HeadLineWidget("Weitere Optionen"),
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
                        ])),
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
        bottomNavigationBar: CustomBottomNavigationBar(
          color: LamaColors.findSubjectColor(blocTaskset.subject ?? "normal"),
          newTask: newTask,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              List<int> listVonBis = [
                int.parse(_vonController.text),
                int.parse(_bisController.text)
              ];
              if(allowedOperations.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: LamaColors.redAccent,
                        content: const Text(
                          'Keine Rechenoperationen ausgewählt',
                          textAlign: TextAlign.center,
                        ),
                        duration: Duration(seconds: 1),
                      ),
                      );
              } else {
              TaskEquation equationTask = TaskEquation(
                  widget.task?.id ??
                      KeyGenerator.generateRandomUniqueKey(blocTaskset.tasks!),
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
                BlocProvider.of<TasksetCreateTasklistBloc>(context)
                    .add(AddToTaskList(equationTask));
                Navigator.pop(context);
              } else {
                // edit Task
                BlocProvider.of<TasksetCreateTasklistBloc>(context)
                    .add(EditTaskInTaskList(widget.index, equationTask));
              }
              Navigator.pop(context);
            }
            }
          },
        ));
  }
}
