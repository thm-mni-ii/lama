import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/bloc/taskset_create_tasklist_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/custom_bottomNavigationBar_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/dynamic_textFormFields_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/headline_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/lamacoin_input_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/text_input_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/widgets/custom_appbar.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/key_generator.dart';

class CreateMatchCategoryScreen extends StatefulWidget {
  final int? index;
  final TaskMatchCategory? task;

  const CreateMatchCategoryScreen(
      {Key? key, required this.index, required this.task})
      : super(key: key);
  @override
  CreateMatchCategoryScreenState createState() =>
      CreateMatchCategoryScreenState();
}

class CreateMatchCategoryScreenState extends State<CreateMatchCategoryScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _rewardController = TextEditingController();
  TextEditingController _category1Controller = TextEditingController();
  TextEditingController _category2Controller = TextEditingController();

  List<TextEditingController> _controllers1 = [];
  List<TextFormField> _fields1 = [];
  List<TextEditingController> _controllers2 = [];
  List<TextFormField> _fields2 = [];

  bool newTask = true;

  @override
  Widget build(BuildContext context) {
    if (widget.task != null && newTask) {
      _rewardController.text = widget.task!.reward.toString();
      _category1Controller.text = widget.task!.nameCatOne.toString();
      _category2Controller.text = widget.task!.nameCatTwo.toString();

      print("1:" + widget.task!.categoryOne.toString());
      print("2:" + widget.task!.categoryTwo.toString());

      DynamicTextFormFields.loadListFromTask(
          _controllers1, _fields1, widget.task!.categoryOne);
      DynamicTextFormFields.loadListFromTask(
          _controllers2, _fields2, widget.task!.categoryTwo);

      newTask = false;
    }
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
                        HeadLineWidget("1. Kategorie"),
                        TextInputWidget(
                          textController: _category1Controller,
                          labelText: "Gib die 1. Kategorie ein",
                        ),
                        DynamicTextFormFields(
                          controllers: _controllers1,
                          fields: _fields1,
                        ),
                        HeadLineWidget("2. Kategorie"),
                        TextInputWidget(
                          textController: _category2Controller,
                          labelText: "Gib die 2. Kategorie ein",
                        ),
                        DynamicTextFormFields(
                          controllers: _controllers2,
                          fields: _fields2,
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
        bottomNavigationBar: CustomBottomNavigationBar(
          color: LamaColors.findSubjectColor(blocTaskset.subject ?? "normal"),
          newTask: newTask,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              TaskMatchCategory taskMatchCategory = TaskMatchCategory(
                widget.task?.id ??
                    KeyGenerator.generateRandomUniqueKey(blocTaskset.tasks!),
                TaskType.matchCategory,
                int.parse(_rewardController.text),
                "Schiebe jedes Wort in die Richtige Kategorie",
                3,
                _category1Controller.text,
                _category2Controller.text,
                _controllers1.map((e) => e.text).toList(),
                _controllers2.map((e) => e.text).toList(),
                null,
                null,
              );
              if (newTask) {
                // add Task
                BlocProvider.of<TasksetCreateTasklistBloc>(context)
                    .add(AddToTaskList(taskMatchCategory));
                Navigator.pop(context);
              } else {
                // edit Task
                BlocProvider.of<TasksetCreateTasklistBloc>(context)
                    .add(EditTaskInTaskList(widget.index, taskMatchCategory));
              }
              Navigator.pop(context);
            }
          },
        ));
  }
}
