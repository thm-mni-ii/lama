import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/event/create_taskset_event.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/bloc/create_task_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_choose_task/screens/taskset_choose_task_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/widgets/custom_appbar.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:lama_app/util/LamaColors.dart';

class MoneyEinstellenScreen extends StatefulWidget {
  @override
  MoneyEinstellenScreenState createState() => MoneyEinstellenScreenState();
}

class MoneyEinstellenScreenState extends State<MoneyEinstellenScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _vonController = TextEditingController();
  TextEditingController _bisController = TextEditingController();
  TextEditingController _rewardController = TextEditingController();

  bool first = true;

/*   @override
  void initState() {
    TaskMoney? task = BlocProvider.of<CreateTaskBloc>(context).task as TaskMoney?;
    if (task != null) {
      von = task.von;
      bis = task.bis;
      reward = task.reward;
    }
    super.initState();
  } */

  @override
  Widget build(BuildContext context) {
    Taskset blocTaskset = BlocProvider.of<CreateTasksetBloc>(context).taskset!;
    TaskMoney? moneyTask =
        BlocProvider.of<CreateTaskBloc>(context).task as TaskMoney?;
    Size screenSize = MediaQuery.of(context).size;

    if (moneyTask != null && first) {
      _vonController.text = moneyTask.von.toString();
      _bisController.text = moneyTask.bis.toString();
      _rewardController.text = moneyTask.reward.toString();

      first = false;
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
                          "Geldbetrag",
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
                                    }
                                    return null;
                                  },
                                  onSaved: (text) =>
                                      _vonController.text = text!,
                                  onChanged: (text) => setState(
                                    () => _vonController.text = text,
                                  ),
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
                                    }
                                    return null;
                                  },
                                  onSaved: (text) {
                                    _bisController.text = text!;
                                  },
                                  onChanged: (text) => setState(
                                    () => _bisController.text = text,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
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
                          onChanged: (String text) => setState(
                            () => _rewardController.text = text,
                          ),
                        ),
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
                    TaskMoney moneyTask = TaskMoney(
                      TaskType.moneyTask,
                      int.parse(_rewardController.text),
                      "",
                      3,
                      double.parse(_vonController.text),
                      double.parse(_bisController.text),
                    );
                    context
                        .read<CreateTasksetBloc>()
                        .add(CreateTasksetAddTask(moneyTask));
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text("Task hinzufügen"),
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
