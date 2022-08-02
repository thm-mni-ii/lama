import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/bloc/taskset_create_tasklist_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/custom_bottomNavigationBar_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/headline_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/lamacoin_input_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/numbers_input_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/widgets/custom_appbar.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/key_generator.dart';

class CreateNumberlineScreen extends StatefulWidget {
  final int? index;
  final TaskNumberLine? task;

  const CreateNumberlineScreen(
      {Key? key, required this.index, required this.task})
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
      randomRangeAllowed = widget.task!.randomrange;
      ontapAllowed = widget.task!.ontap;
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
                        validator: (text) {
                          if (int.parse(text) <= 0) {
                            return "Zu klein";
                          } else if ((int.parse(_bisController.text) -
                                      int.parse(_vonController.text)) %
                                  int.parse(text) !=
                              0) {
                            return "Step size sollte ein Teiler vom ende - start sein";
                          }
                          return null;
                        },
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
        bottomNavigationBar: CustomBottomNavigationBar(
          color: LamaColors.findSubjectColor(blocTaskset.subject ?? "normal"),
          newTask: newTask,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              List<int> list = [
                int.parse(_vonController.text),
                int.parse(_bisController.text)
              ];
              TaskNumberLine taskNumberLine = TaskNumberLine(
                  widget.task?.id ??
                      KeyGenerator.generateRandomUniqueKey(blocTaskset.tasks!),
                  TaskType.numberLine,
                  int.parse(_rewardController.text),
                  "Gib den im Zahlenstrahl rot markierten Wert an!",
                  3,
                  list,
                  randomRangeAllowed!,
                  int.parse(_stepsController.text),
                  ontapAllowed!);
              if (newTask) {
                // <=> widget.task == null
                // add Task
                BlocProvider.of<TasksetCreateTasklistBloc>(context)
                    .add(AddToTaskList(taskNumberLine));
                Navigator.pop(context);
              } else {
                // edit Task
                BlocProvider.of<TasksetCreateTasklistBloc>(context)
                    .add(EditTaskInTaskList(widget.index, taskNumberLine));
              }
              Navigator.pop(context);
            }
          },
        ));
  }
}
