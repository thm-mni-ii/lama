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

class MoneyEinstellenScreen extends StatefulWidget {
  final TaskMoney? task;

  const MoneyEinstellenScreen({Key? key, required this.task}) : super(key: key);
  @override
  MoneyEinstellenScreenState createState() => MoneyEinstellenScreenState();
}

class MoneyEinstellenScreenState extends State<MoneyEinstellenScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _vonController = TextEditingController();
  TextEditingController _bisController = TextEditingController();
  TextEditingController _rewardController = TextEditingController();

  bool newTask = true;

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
      _vonController.text = widget.task!.difficulty.toString();
      _rewardController.text = widget.task!.reward.toString();

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
                      margin: EdgeInsets.only(top: 25),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Schwierigkeit",
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
                                    labelText: 'Schwierigkeit',
                                  ),
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return "Schwierigkeit fehlt!";
                                    }
                                    return null;
                                  },
                                  onSaved: (text) =>
                                      _vonController.text = text!,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30),
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
                      TaskMoney moneyTask = TaskMoney(
                        widget.task?.id ??
                            KeyGenerator.generateRandomUniqueKey(
                                blocTaskset.tasks!),
                        TaskType.moneyTask,
                        int.parse(_rewardController.text),
                        "",
                        3,
                        int.parse(_vonController.text),
                        true
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
