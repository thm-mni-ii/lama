import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/event/create_taskset_event.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_choose_task/screens/taskset_choose_task_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/widgets/custom_appbar.dart';
import 'package:lama_app/app/screens/task_screen.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/key_generator.dart';

class MoneyEinstellenScreen extends StatefulWidget {
  final TaskMoney? task;

  const MoneyEinstellenScreen({Key? key, required this.task}) : super(key: key);
  @override
  MoneyEinstellenScreenState createState() => MoneyEinstellenScreenState();
}

class MoneyEinstellenScreenState extends State<MoneyEinstellenScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _difController = TextEditingController();
  TextEditingController _rewardController = TextEditingController();
  TextEditingController _leftToSolveController = TextEditingController();

  bool newTask = true;
  bool? optimumAllowed = false;

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

    if (widget.task != null && newTask) {
      _difController.text = widget.task!.difficulty.toString();
      _rewardController.text = widget.task!.reward.toString();
      _leftToSolveController.text = widget.task!.optimum.toString();

      newTask = false;
    }

    return Scaffold(
      appBar: CustomAppbar(
        size: screenSize.width / 5,
        titel: "MoneyTask",
        color: LamaColors.findSubjectColor(blocTaskset.subject ?? "normal"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(5),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 30, left: 5, right: 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Schwierigkeitsgrad",
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
                                margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                                child: TextFormField(
                                  controller: _difController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Schwierigkeit von 1 bis 5',
                                  ),
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return "Schwierigkeit fehlt!";
                                    }
                                    return null;
                                  },
                                  onSaved: (text) =>
                                  _difController.text = text!,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 5, right: 5),
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
                      margin: EdgeInsets.only(left: 15, bottom: 15, right: 30),
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
                    Container(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Optimum",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          CheckboxListTile(
                            title: Text("Optimum allowed"),
                            value: optimumAllowed,
                            onChanged: (bool? value) {
                              setState(() {
                                optimumAllowed = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10, left: 0, right: 5),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Bleibt zu lösen ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10, left: 0, right: 5),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Wie oft die Aufgabe richtig gelöst werden kann bevor es keine Münzen als Belohnung mehr gibt, Ganzzahl > 0",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 0, bottom: 15, right: 30),
                            child: TextFormField(
                              controller: _leftToSolveController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Bleibt zu lösen: von 1 bis 3',
                              ),
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return "Beitrag fehlt!";
                                }
                                return null;
                              },
                              onSaved: (String? text) =>
                              _leftToSolveController.text = text!,
                            ),
                          ),
                        ],
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
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      TaskMoney moneytask = TaskMoney(
                          widget.task?.id ??
                              KeyGenerator.generateRandomUniqueKey(
                                  blocTaskset.tasks!),
                          TaskType.moneyTask,
                          int.parse(_rewardController.text),
                          "",
                          3,
                          int.parse(_difController.text),
                          true);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => TaskScreen(blocTaskset.grade)));
                    }
                  },
/*                   onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<CreateTasksetBloc>(context),
                        child: TasksetChooseTaskScreen(),
                      ),
                    ),
                  ), */
                  child: const Text("Preview"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      TaskMoney moneyTask = TaskMoney(
                        widget.task?.id ??
                            KeyGenerator.generateRandomUniqueKey(
                                blocTaskset.tasks!),
                        TaskType.moneyTask,
                        int.parse(_rewardController.text),
                        "",
                        3,
                        int.parse(_difController.text),
                        optimumAllowed
                      );
                      if (newTask) {
                        // add Task
                        BlocProvider.of<CreateTasksetBloc>(context)
                            .add(AddTask(moneyTask));
                        Navigator.pop(context);
                      } else {
                        // edit Task
                        BlocProvider.of<CreateTasksetBloc>(context)
                            .add(EditTask(moneyTask));
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

class Item {
  Item({
    required this.id,
    required this.expandedValue,
    required this.headerValue,
  });

  int id;
  String expandedValue;
  String headerValue;
}

List<Item> generateItems(int numberOfItems) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      id: index,
      headerValue: 'Erweiterte Optionen',
      expandedValue: "Nur volle Euro",
    );
  });
}
