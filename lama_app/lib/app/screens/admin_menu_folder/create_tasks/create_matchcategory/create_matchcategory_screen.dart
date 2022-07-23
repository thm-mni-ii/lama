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

class CreateMatchCategoryScreen extends StatefulWidget {
  final TaskMatchCategory? task;

  const CreateMatchCategoryScreen({Key? key, required this.task})
      : super(key: key);
  @override
  CreateMatchCategoryScreenState createState() =>
      CreateMatchCategoryScreenState();
}

class CreateMatchCategoryScreenState extends State<CreateMatchCategoryScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _rewardController = TextEditingController();
  TextEditingController _questionController = TextEditingController();
  TextEditingController _rightAnswer = TextEditingController();
  TextEditingController _wrongAnswer1 = TextEditingController();
  TextEditingController _wrongAnswer2 = TextEditingController();

  List<TextEditingController> _controllers1 = [];
  List<TextFormField> _fields1 = [];
  List<TextEditingController> _controllers2 = [];
  List<TextFormField> _fields2 = [];

  bool newTask = true;

  @override
  Widget build(BuildContext context) {
    Taskset blocTaskset = BlocProvider.of<CreateTasksetBloc>(context).taskset!;
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
        appBar: CustomAppbar(
          size: screenSize.width / 5,
          titel: "Match Category",
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
                          margin: EdgeInsets.only(top: 30, left: 5, right: 5),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "1. Kategorie",
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
                            controller: _questionController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: 'Gib die 1. Kategorie ein',
                            ),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return "Die Kategorie fehlt!";
                              }
                              return null;
                            },
                            onSaved: (String? text) =>
                                _questionController.text = text!,
                          ),
                        ),
                        _addTile1(),
                        _listView1(),
                        Container(
                          margin: EdgeInsets.only(top: 30, left: 5, right: 5),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "2. Kategorie",
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
                            controller: _questionController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: 'Gib die 2. Kategorie ein',
                            ),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return "Die Kategorie fehlt!";
                              }
                              return null;
                            },
                            onSaved: (String? text) =>
                                _questionController.text = text!,
                          ),
                        ),
                        _addTile2(),
                        _listView2(),
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
                TaskClozeTest task4Cards = TaskClozeTest(
                    widget.task?.id ??
                        KeyGenerator.generateRandomUniqueKey(
                            blocTaskset.tasks!),
                    TaskType.matchCategory,
                    int.parse(_rewardController.text),
                    "Tippe die richtige Antwort an!",
                    3,
                    _questionController.text,
                    _rightAnswer.text,
                    [
                      _wrongAnswer1.text,
                      _wrongAnswer2.text,
                    ]);
                if (newTask) {
                  // add Task
                  BlocProvider.of<CreateTasksetBloc>(context)
                      .add(AddTask(task4Cards));
                  Navigator.pop(context);
                } else {
                  // edit Task
                  BlocProvider.of<CreateTasksetBloc>(context)
                      .add(EditTask(task4Cards));
                }
                Navigator.pop(context);
              }
            },
            child: Text(newTask ? "Task hinzufügen" : "verändere Task"),
          ),
        )
    );
  }

  Widget _addTile1() {
    return ListTile(
      title: Text("Füge einen Begriff hinzu"),
      trailing: Icon(Icons.add),
      onTap: () {
        final TextEditingController controller = TextEditingController();
        final TextFormField textFormField = TextFormField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            border: OutlineInputBorder(),
            labelText: "${_fields1.length + 1}. Begriff",
          ),
        );
        setState(() {
          _controllers1.add(controller);
          _fields1.add(textFormField);
        });
      },
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

  Widget _addTile2() {
    return ListTile(
      title: Text("Füge einen Begriff hinzu"),
      trailing: Icon(Icons.add),
      onTap: () {
        final TextEditingController controller = TextEditingController();
        final TextFormField textFormField = TextFormField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            border: OutlineInputBorder(),
            labelText: "${_fields2.length + 1}. Begriff",
          ),
        );
        setState(() {
          _controllers2.add(controller);
          _fields2.add(textFormField);
        });
      },
    );
  }

  Widget _listView2() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _fields2.length,
      itemBuilder: (context, index) {
        print(_fields2.length);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                width: MediaQuery.of(context).size.width / 2,
                margin: EdgeInsets.only(top: 20),
                child: _fields2[index]),
            Container(
                margin: EdgeInsets.only(top: 20),
                width: MediaQuery.of(context).size.width / 5,
                child: IconButton(onPressed: () {}, icon: Icon(Icons.delete)))
          ],
        );
      },
    );
  }
}
