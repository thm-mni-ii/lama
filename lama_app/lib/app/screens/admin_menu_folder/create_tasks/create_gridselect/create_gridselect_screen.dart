import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/event/create_taskset_event.dart';
import 'package:lama_app/app/screens/admin_menu_folder/bloc/taskset_create_tasklist_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/dynamic_textFormFields_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/headline_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/lamacoin_input_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/text_input_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/widgets/custom_appbar.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/key_generator.dart';

class CreateGridSelectScreen extends StatefulWidget {
  final TaskGridSelect? task;
  final int? index;

  const CreateGridSelectScreen({Key? key, required this.task, required this.index})
      : super(key: key);
  @override
  CreateGridSelectScreenState createState() => CreateGridSelectScreenState();
}

class CreateGridSelectScreenState extends State<CreateGridSelectScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _rewardController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  List<TextEditingController> _controllers = [];
  List<TextFormField> _fields = [];

  bool newTask = true;

  @override
  Widget build(BuildContext context) {
    final tasksetListProvider = BlocProvider.of<TasksetCreateTasklistBloc>(context);
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
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        HeadLineWidget("Kategorie"),
                        TextInputWidget(
                          textController: _categoryController,
                          missingInput: "Angabe fehlt",
                          labelText: "Gib die Kategorie ein",
                        ),
                        HeadLineWidget("Begriffe"),
                        DynamicTextFormFields(
                          controllers: _controllers,
                          fields: _fields,
                        ),
                        HeadLineWidget("Erreichbare Lamacoins"),
                        LamacoinInputWidget(
                          numberController: _rewardController,
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
                TaskGridSelect taskMatchCategory = TaskGridSelect(
                  widget.task?.id ??
                      KeyGenerator.generateRandomUniqueKey(blocTaskset.tasks!),
                  TaskType.gridSelect,
                  int.parse(_rewardController.text),
                  "Markiere X ${_categoryController.text}",
                  3,
                  //TODO: Klappt das wirklich?
                  _controllers.map((e) => e.text).toList(),
                );
                if (newTask) {
                  // add Task
                  tasksetListProvider.add(AddToTaskList(taskMatchCategory));
                  Navigator.pop(context);
                } else {
                  // edit Task
                  tasksetListProvider.add(
                    EditTaskInTaskList(widget.index, taskMatchCategory),
                  );
                Navigator.pop(context);
              }
              }
            },
            child: Text(newTask ? "Task hinzufügen" : "verändere Task"),
          ),
        ));
  }
}