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

class CreateGridSelectScreen extends StatefulWidget {
  final TaskGridSelect? task;

  const CreateGridSelectScreen({Key? key, required this.task}) : super(key: key);
  @override
  CreateGridSelectScreenState createState() => CreateGridSelectScreenState();
}

class CreateGridSelectScreenState extends State<CreateGridSelectScreen> {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _aufgabeController = TextEditingController();
  TextEditingController _rewardController = TextEditingController();

  List<TextEditingController> _controllers1 = [];
  List<TextFormField> _fields1 = [];

  bool newTask = true;




  @override
  Widget build(BuildContext context) {
    Taskset blocTaskset = BlocProvider.of<CreateTasksetBloc>(context).taskset!;
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppbar(
        size: screenSize.width / 5,
        titel: "Gridselect",
        color: LamaColors.findSubjectColor(blocTaskset.subject ?? "normal"),
      ),
      body: Column(
        children: [
          Expanded(child: SingleChildScrollView(
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
                          "Aufgabenstellung",
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
                        controller: _aufgabeController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'Gib die Aufgabe an',
                        ),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return "Die Aufgabe fehlt!";
                          }
                          return null;
                        },
                        onSaved: (String? text) =>
                        _aufgabeController.text = text!,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30, left: 5, right: 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Gesuchte Wörte",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    _addTile1(),
                    _listView1(),
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
                            return "Betrag fehlt!";
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
          ))
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
                TaskGridSelect taskGridSelect = TaskGridSelect(
                    widget.task?.id ??
                        KeyGenerator.generateRandomUniqueKey(
                            blocTaskset.tasks!),
                    TaskType.gridSelect,
                    int.parse(_rewardController.text),
                    _aufgabeController.text,
                    3,
                    [
                      // todo parsing
                      _fields1.elementAt(0).toString(),
                      _fields1.elementAt(1).toString(),
                    ]);
                if (newTask) {
                  // add Task
                  BlocProvider.of<CreateTasksetBloc>(context)
                      .add(AddTask(taskGridSelect));
                  Navigator.pop(context);
                } else {
                  // edit Task
                  BlocProvider.of<CreateTasksetBloc>(context)
                      .add(EditTask(taskGridSelect));
                }
                Navigator.pop(context);
              }
            },
            child: Text(newTask ? "Task hinzufügen" : "verändere Task"),
          ),
        )
    );
  }

  Widget _listView1() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _fields1.length,
      itemBuilder: (context, index) {
        print(_fields1.length);
        return Container(margin: EdgeInsets.all(5), child: _fields1[index]);
      },
    );
  }

  Widget _addTile1() {
    return ListTile(
      title: Text("Füge ein Wort hinzu"),
      trailing: Icon(Icons.add),
      onTap: () {
        final TextEditingController controller = TextEditingController();
        final TextFormField textFormField = TextFormField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            border: OutlineInputBorder(),
            labelText: "${_fields1.length + 1}. Wort",
          ),
        );
        setState(() {
          _controllers1.add(controller);
          _fields1.add(textFormField);
        });
      },
    );
  }




}


