import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/event/create_taskset_event.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_choose_task/screens/taskset_choose_task_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/widgets/custom_appbar.dart';
import 'package:lama_app/app/screens/task_type_screens/zerlegung_task_screen.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/key_generator.dart';

class CreateZerlegungScreen extends StatefulWidget {
  final TaskZerlegung? task;

  const CreateZerlegungScreen({Key? key, required this.task}) : super(key: key);
  @override
  CreateZerlegungScreenState createState() => CreateZerlegungScreenState();
}

class CreateZerlegungScreenState extends State<CreateZerlegungScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _rewardController = TextEditingController();

  bool newTask = true;
  bool? reverseAllowed = false;
  bool? boolThousandsAllowed = false;
  bool? zerosAllowed = false;

  @override
  Widget build(BuildContext context) {
    Taskset blocTaskset = BlocProvider.of<CreateTasksetBloc>(context).taskset!;
    Size screenSize = MediaQuery.of(context).size;

    if (widget.task != null && newTask) {
      _rewardController.text = widget.task!.reward.toString();

      newTask = false;
    }

    return Scaffold(
        appBar: CustomAppbar(
          size: screenSize.width / 5,
          titel: "Zerlegung",
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
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Optionen",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          CheckboxListTile(
                            title: Text("Reihenfolge umkehren"),
                            subtitle: Text(
                                "Aktiviert: E-Z-H-T\nDeaktiviert: T-H-Z-E"),
                            value: reverseAllowed,
                            onChanged: (bool? value) {
                              setState(() {
                                reverseAllowed = value;
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: Text("Nullen in Zahl erlauben"),
                            subtitle: Text(
                                "Aktiviert: Es sind Nullen als Ziffern erlaubt\nDeaktiviert: Es sind keine Nullen erlaubt"),
                            value: zerosAllowed,
                            onChanged: (bool? value) {
                              setState(() {
                                zerosAllowed = value;
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: Text("Tausender erlauben"),
                            subtitle: Text(
                                "Aktiviert: Zahlen gehen bis 9999\nDeaktiviert: Zahlen gehen bis 999"),
                            value: boolThousandsAllowed,
                            onChanged: (bool? value) {
                              setState(() {
                                boolThousandsAllowed = value;
                              });
                            },
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 30, left: 5, right: 5),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Task Belohnung",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: 15, bottom: 15, right: 30),
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
                  ],
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
                TaskZerlegung zerlegungTask = TaskZerlegung(
                    widget.task?.id ??
                        KeyGenerator.generateRandomUniqueKey(
                            blocTaskset.tasks!),
                    TaskType.zerlegung,
                    int.parse(_rewardController.text),
                    "zerlegt die Zahlen!",
                    3,
                    reverseAllowed,
                    zerosAllowed,
                    boolThousandsAllowed);
                if (newTask) {
                  // add Task
                  BlocProvider.of<CreateTasksetBloc>(context)
                      .add(AddTask(zerlegungTask));
                  Navigator.pop(context);
                } else {
                  // edit Task
                  BlocProvider.of<CreateTasksetBloc>(context)
                      .add(EditTask(zerlegungTask));
                }
                Navigator.pop(context);
              }
            },
            child: Text(newTask ? "Task hinzufügen" : "verändere Task"),
          ),
        ));
  }
}
