import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/bloc/taskset_create_tasklist_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/widgets/custom_appbar.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/key_generator.dart';

class CreateTaskNumberLine extends StatefulWidget {
  final int index;
  final TaskNumberLine? task;
  const CreateTaskNumberLine(
      {Key? key, required this.index, required this.task})
      : super(key: key);

  @override
  State<CreateTaskNumberLine> createState() => _CreateTaskNumberLineState();
}

class _CreateTaskNumberLineState extends State<CreateTaskNumberLine> {
  TextEditingController _startController = TextEditingController();
  TextEditingController _endController = TextEditingController();
  TextEditingController _rewardController = TextEditingController();
  TextEditingController _stepSizeController = TextEditingController();

  bool newTask = true;

  bool _changeSettings = true;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TasksetCreateTasklistBloc blocTaskList =
        BlocProvider.of<TasksetCreateTasklistBloc>(context);
    CreateTasksetBloc bloc = BlocProvider.of<CreateTasksetBloc>(context);
    Taskset blocTaskset = bloc.taskset!;
    Size screenSize = MediaQuery.of(context).size;

    if (widget.task != null && newTask) {
      _startController.text = widget.task!.range.first.toString();
      _endController.text = widget.task!.range.last.toString();
      _rewardController.text = widget.task!.reward.toString();
      _changeSettings = widget.task!.ontap!;
      _stepSizeController.text = widget.task!.steps.toString();

      newTask = false;
    }

    return Scaffold(
      appBar: CustomAppbar(
        size: screenSize.width / 5,
        titel: "NumberLineTask",
        color: LamaColors.findSubjectColor(blocTaskset.subject ?? "normal"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Determin Position"),
                    Switch.adaptive(
                      value: _changeSettings,
                      onChanged: (bool value) {
                        setState(() => _changeSettings = value);
                      },
                    ),
                    Text("Genererate Position"),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: screenSize.width * 0.4,
                    margin: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _startController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Von'),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return "Beitrag fehlt!";
                        } else if (int.parse(_endController.text) <=
                            int.parse(text)) {
                          return "Zu groß";
                        }
                        return null;
                      },
                      onSaved: (text) => _startController.text = text!,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    width: screenSize.width * 0.4,
                    child: TextFormField(
                      controller: _endController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Bis'),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return "Beitrag fehlt!";
                        } else if (int.parse(text) <=
                            int.parse(_startController.text)) {
                          return "Zu klein";
                        }
                        return null;
                      },
                      onSaved: (text) => _endController.text = text!,
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _stepSizeController,
                  decoration: InputDecoration(hintText: "Step size"),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return "Beitrag fehlt!";
                    } else if (int.parse(text) <= 0) {
                      return "Zu klein";
                    } else if ((int.parse(_endController.text) -
                                int.parse(_startController.text)) %
                            int.parse(text) !=
                        0) {
                      return "Step size sollte ein Teiler vom ende - start sein";
                    }
                    return null;
                  },
                  onSaved: (text) => _stepSizeController.text = text!,
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _rewardController,
                  decoration: InputDecoration(hintText: "Rewards"),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return "Beitrag fehlt!";
                    } else if (int.parse(text) <= 0) return "Zu klein";
                    return null;
                  },
                  onSaved: (text) => _rewardController.text = text!,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {
/*                 if (_formKey.currentState!.validate()) {
                  TaskNumberLine numberLineTask = TaskNumberLine(
                    widget.task?.id ??
                        KeyGenerator.generateRandomUniqueKey(
                          blocTaskset.tasks!,
                        ),
                    TaskType.numberLine,
                    int.parse(_rewardController.text),
                    "Gib den im Zahlenstrahl rot markierten Wert an!",
                    3,
                    [
                      int.parse(_startController.text),
                      int.parse(_endController.text)
                    ],
                    false, // a random range or (start - end)
                    1,
                    _changeSettings,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LayoutBuilder(
                          builder: (context, constraints) => Scaffold(
                                body: NumberLineTaskScreen(
                                    numberLineTask, constraints),
                              )),
                    ),
                  );
                } */
              },
              child: const Text("Preview"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  TaskNumberLine numberLineTask = TaskNumberLine(
                    widget.task?.id ??
                        KeyGenerator.generateRandomUniqueKey(
                          blocTaskset.tasks!,
                        ),
                    TaskType.numberLine,
                    int.parse(_rewardController.text),
                    "Gib den im Zahlenstrahl rot markierten Wert an!",
                    3,
                    [
                      int.parse(_startController.text),
                      int.parse(_endController.text)
                    ],
                    false, // a random range or (start - end)
                    1,
                    _changeSettings,
                    null,
                    null,
                  );
                  if (newTask) {
                    // add Task
                    blocTaskList.add(AddToTaskList(numberLineTask));
                    Navigator.pop(context);
                  } else {
                    // edit Task
                    blocTaskList.add(
                      EditTaskInTaskList(widget.index, numberLineTask),
                    );
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(newTask ? "Task hinzufügen" : "verändere Task"),
            )
          ],
        ),
      ),
    );
  }
}
