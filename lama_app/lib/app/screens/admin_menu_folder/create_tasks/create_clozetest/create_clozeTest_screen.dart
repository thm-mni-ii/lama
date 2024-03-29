import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/bloc/taskset_create_tasklist_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/custom_bottomNavigationBar_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/lamacoin_input_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/text_input_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/widgets/custom_appbar.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/key_generator.dart';

import '../widgets/headline_widget.dart';

class CreateClozeTestScreen extends StatefulWidget {
  final int? index;
  final TaskClozeTest? task;

  const CreateClozeTestScreen(
      {Key? key, required this.index, required this.task})
      : super(key: key);
  @override
  CreateClozeTestScreenState createState() => CreateClozeTestScreenState();
}

class CreateClozeTestScreenState extends State<CreateClozeTestScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _rewardController = TextEditingController();
  TextEditingController _questionController = TextEditingController();
  TextEditingController _rightAnswer = TextEditingController();
  TextEditingController _wrongAnswer1 = TextEditingController();
  TextEditingController _wrongAnswer2 = TextEditingController();

  bool newTask = true;

  @override
  Widget build(BuildContext context) {
    if (widget.task != null && newTask) {
      _rewardController.text = widget.task!.reward.toString();
      _questionController.text = widget.task!.question.toString();
      _rightAnswer.text = widget.task!.rightAnswer.toString();
      _wrongAnswer1.text = widget.task!.wrongAnswers[0];
      _wrongAnswer2.text = widget.task!.wrongAnswers[1];

      newTask = false;
    }
    Taskset blocTaskset = BlocProvider.of<CreateTasksetBloc>(context).taskset!;
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppbar(
        size: screenSize.width / 5,
        titel: "Cloze Test",
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
                      HeadLineWidget("Satz"),
                      TextInputWidget(
                        textController: _questionController,
                        labelText: "Gib den Satz ein",
                      ),
                      HeadLineWidget("Gesuchte Wort"),
                      TextInputWidget(
                        textController: _rightAnswer,
                        labelText: "Gib das gesuchte Wort ein",
                      ),
                      HeadLineWidget("Falsche Antworten"),
                      TextInputWidget(
                        textController: _wrongAnswer1,
                        labelText: "Gib ein falsches Wort ein",
                      ),
                      TextInputWidget(
                        textController: _wrongAnswer2,
                        labelText: "Gib ein falsches Wort ein",
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
      bottomNavigationBar: CustomBottomNavigationBar(
          color: LamaColors.findSubjectColor(blocTaskset.subject ?? "normal"),
          newTask: newTask,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              TaskClozeTest taskClozeTest = TaskClozeTest(
                  widget.task?.id ??
                      KeyGenerator.generateRandomUniqueKey(blocTaskset.tasks!),
                  TaskType.clozeTest,
                  int.parse(_rewardController.text),
                  "Tippe die richtige Antwort an!",
                  3,
                  _questionController.text,
                  _rightAnswer.text,
                  null,
                  null,
                  [
                    _wrongAnswer1.text,
                    _wrongAnswer2.text,
                  ]);
              if (newTask) {
                // add Task
                BlocProvider.of<TasksetCreateTasklistBloc>(context)
                    .add(AddToTaskList(taskClozeTest));
                Navigator.pop(context);
              } else {
                // edit Task
                BlocProvider.of<TasksetCreateTasklistBloc>(context)
                    .add(EditTaskInTaskList(widget.index, taskClozeTest));
              }
              Navigator.pop(context);
            }
          }),
    );
  }
}
