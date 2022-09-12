import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/bloc/taskset_create_tasklist_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/dynamic_doubleTextFormfield/dynamic_doubleTextFormFields_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/dynamic_doubleTextFormfield/two_controller.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/dynamic_doubleTextFormfield/two_textFields.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/headline_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/lamacoin_input_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/widgets/custom_appbar.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/key_generator.dart';

class CreateVocabletestScreen extends StatefulWidget {
  final int? index;
  final TaskVocableTest? task;

  const CreateVocabletestScreen({
    Key? key,
    required this.task,
    required this.index,
  }) : super(key: key);
  @override
  CreateVocabletestScreenState createState() => CreateVocabletestScreenState();
}

class CreateVocabletestScreenState extends State<CreateVocabletestScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _rewardController = TextEditingController();
  List<TwoControllers> _controllers = [];
  TwoControllers twoController = TwoControllers();
  List<TwoTextfields> _fields = [];
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  bool? randomSide = false;

  bool newTask = true;
  @override
  Widget build(BuildContext context) {
    if (widget.task != null && newTask) {
      _rewardController.text = widget.task!.reward.toString();
      int controllersLength = widget.task!.vocablePairs.length;
      for (int i = 0; i < controllersLength; i++) {
        _controllers.add(twoController);
        _fields.add(TwoTextfields(
          controller1: _controllers[i].controller1,
          controller2: _controllers[i].controller2,
          index: i,
          initialValue1: widget.task!.vocablePairs[i].a,
          initialValue2: widget.task!.vocablePairs[i].b,
        ));
      }
      newTask = false;
    }

    Taskset blocTaskset = BlocProvider.of<CreateTasksetBloc>(context).taskset!;
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
        appBar: CustomAppbar(
          size: screenSize.width / 5,
          titel: "Vokabeltest",
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
                        DynamicDoubleTextFormFields(
                          controllers: _controllers,
                          fields: _fields,
                          labelText1: "Englisch",
                          labelText2: "Deutsch",
                        ),
                        HeadLineWidget("Weitere Optionen"),
                        CheckboxListTile(
                          title: Text("Übersetzung in beide Richtungen"),
                          value: randomSide,
                          onChanged: (bool? value) {
                            setState(() {
                              randomSide = value;
                            });
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
                TaskVocableTest taskMatchCategory = TaskVocableTest(
                  widget.task?.id ??
                      KeyGenerator.generateRandomUniqueKey(blocTaskset.tasks!),
                  TaskType.vocableTest,
                  int.parse(_rewardController.text),
                  "Translate the shown word!",
                  3,
                  [],
                  randomSide,
                  "Englisch",
                  "Deutsch",
                );
                if (newTask) {
                  // <=> widget.task == null
                  // add Task
                  BlocProvider.of<TasksetCreateTasklistBloc>(context)
                      .add(AddToTaskList(taskMatchCategory));
                  Navigator.pop(context);
                } else {
                  // edit Task
                  BlocProvider.of<TasksetCreateTasklistBloc>(context)
                      .add(EditTaskInTaskList(widget.index, taskMatchCategory));
                }
               print(_controllers[0].controller1!.text.toString());
                Navigator.pop(context);
              }
            },
            child: Text(newTask ? "Task hinzufügen" : "verändere Task"),
          ),
        ));
  }
}
