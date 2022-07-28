import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/event/create_taskset_event.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/dropdown_widget_String.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/headline_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/numbers_input_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/widgets/custom_appbar.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/key_generator.dart';

import '../widgets/lamacoin_input_widget.dart';

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
  String? _currentSelectedDifficulty;

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
        resizeToAvoidBottomInset: false,
        appBar: CustomAppbar(
          size: screenSize.width / 5,
          titel: "MoneyTask",
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
                        HeadLineWidget("Schwierigkeitsgrad"),
                        DropdownWidgetString(
                          hintText: "Auswählen",
                          itemsList: ['1', '2', '3'],
                          onChanged: (value) {
                            _currentSelectedDifficulty = value;
                          },
                        ),
                        Container(
                          child: Column(
                            children: [
                              HeadLineWidget("Weitere Optionen"),
                              CheckboxListTile(
                                title: Text("Nur die optimale Lösung zulassen"),
                                value: optimumAllowed,
                                onChanged: (bool? value) {
                                  setState(() {
                                    optimumAllowed = value;
                                    print(_currentSelectedDifficulty);
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
                TaskMoney moneyTask = TaskMoney(
                    widget.task?.id ??
                        KeyGenerator.generateRandomUniqueKey(
                            blocTaskset.tasks!),
                    TaskType.moneyTask,
                    int.parse(_rewardController.text),
                    "",
                    3,
                    int.parse(_currentSelectedDifficulty.toString()),
                    optimumAllowed);
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
                print(moneyTask.difficulty);
                Navigator.pop(context);
              }
            },
            child: Text(newTask ? "Task hinzufügen" : "verändere Task"),
          ),
        ));
  }
}
