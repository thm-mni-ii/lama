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

class CreateMarkWordsScreen extends StatefulWidget {
  final int? index;
  final TaskMarkWords? task;

  const CreateMarkWordsScreen(
      {Key? key, required this.task, required this.index})
      : super(key: key);
  @override
  CreateMarkWordsScreenState createState() => CreateMarkWordsScreenState();
}

class CreateMarkWordsScreenState extends State<CreateMarkWordsScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _rewardController = TextEditingController();
  TextEditingController _taskController = TextEditingController();
  TextEditingController _sentenceController = TextEditingController();
  List<TextEditingController> _controllers = [];
  List<TextFormField> _fields = [];

  bool newTask = true;
  @override
  Widget build(BuildContext context) {
    if (widget.task != null && newTask) {
      _rewardController.text = widget.task!.reward.toString();
      _sentenceController.text = widget.task!.sentence.toString();
      _taskController.text = widget.task!.lamaText.toString();

      DynamicTextFormFields.loadListFromTask(
          _controllers, _fields, widget.task!.rightWords);

      newTask = false;
    }
    final tasksetListProvider =
        BlocProvider.of<TasksetCreateTasklistBloc>(context);
    Taskset blocTaskset = BlocProvider.of<CreateTasksetBloc>(context).taskset!;
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
        appBar: CustomAppbar(
          size: screenSize.width / 5,
          titel: "Mark Words",
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
                        HeadLineWidget("Aufgabenstellung"),
                        TextInputWidget(
                          textController: _taskController,
                          labelText: "Gib die Aufgabenstellung ein",
                        ),
                        HeadLineWidget("Satz"),
                        TextInputWidget(
                          textController: _sentenceController,
                          labelText: "Gib den Satz ein",
                        ),
                        HeadLineWidget("Richtige Wörter"),
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
        bottomNavigationBar: CustomBottomNavigationBar(
          color: LamaColors.findSubjectColor(blocTaskset.subject ?? "normal"),
          newTask: newTask,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              TaskMarkWords taskMarkWords = TaskMarkWords(
                widget.task?.id ??
                    KeyGenerator.generateRandomUniqueKey(blocTaskset.tasks!),
                TaskType.markWords,
                int.parse(_rewardController.text),
                _taskController.text,
                3,
                _sentenceController.text,
                _controllers.map((e) => e.text).toList(),
                null,
                null,
              );
              if (newTask) {
                // add Task
                tasksetListProvider.add(AddToTaskList(taskMarkWords));
                Navigator.pop(context);
              } else {
                // edit Task
                tasksetListProvider.add(
                  EditTaskInTaskList(widget.index, taskMarkWords),
                );
              }
              Navigator.pop(context);
            }
          },
        ));
  }
}
