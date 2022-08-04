import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/bloc/taskset_create_tasklist_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/custom_bottomNavigationBar_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/headline_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/text_input_widget.dart';
import 'package:lama_app/app/screens/admin_menu_folder/widgets/custom_appbar.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/key_generator.dart';

import '../widgets/lamacoin_input_widget.dart';

class CreateFourCardsScreen extends StatefulWidget {
  final int? index;
  final Task4Cards? task;

  const CreateFourCardsScreen(
      {Key? key, required this.index, required this.task})
      : super(key: key);
  @override
  CreateFourCardsScreenState createState() => CreateFourCardsScreenState();
}

class CreateFourCardsScreenState extends State<CreateFourCardsScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _rewardController = TextEditingController();
  TextEditingController _questionController = TextEditingController();
  List<TextEditingController> _answers =
      List<TextEditingController>.generate(4, (i) => TextEditingController());

  bool newTask = true;

  @override
  Widget build(BuildContext context) {
    if (widget.task != null && newTask) {
      _rewardController.text = widget.task!.reward.toString();
      _questionController.text = widget.task!.question.toString();
      _answers[0].text = widget.task!.rightAnswer.toString();
      _answers[1].text = widget.task!.wrongAnswers[0].toString();
      _answers[2].text = widget.task!.wrongAnswers[1].toString();
      _answers[3].text = widget.task!.wrongAnswers[2].toString();

      newTask = false;
    }

    Taskset blocTaskset = BlocProvider.of<CreateTasksetBloc>(context).taskset!;
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
        appBar: CustomAppbar(
          size: screenSize.width / 5,
          titel: "Four Cards",
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
                        HeadLineWidget("Frage"),
                        TextInputWidget(
                            textController: _questionController,
                            labelText: "Gib die Frage ein"),
                        HeadLineWidget("Richtige Antwort"),
                        TextInputWidget(
                          textController: _answers[0],
                          labelText: "Gib die richtige Antwort ein",
                        ),
                        HeadLineWidget("Falsche Antworten"),
                        TextInputWidget(
                          textController: _answers[1],
                          labelText: "Gib eine falsche Antwort ein",
                        ),
                        TextInputWidget(
                          textController: _answers[2],
                          labelText: "Gib eine falsche Antwort ein",
                        ),
                        TextInputWidget(
                          textController: _answers[3],
                          labelText: "Gib eine falsche Antwort ein",
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
              Task4Cards task4Cards = Task4Cards(
                  widget.task?.id ??
                      KeyGenerator.generateRandomUniqueKey(blocTaskset.tasks!),
                  TaskType.fourCards,
                  int.parse(_rewardController.text),
                  "Tippe die richtige Antwort an!",
                  3,
                  _questionController.text,
                  _answers[0].text,
                  null,
                  null,
                  [_answers[1].text, _answers[2].text, _answers[3].text]);
              if (newTask) {
                // add Task
                BlocProvider.of<TasksetCreateTasklistBloc>(context)
                    .add(AddToTaskList(task4Cards));
                Navigator.pop(context);
              } else {
                // edit Task
                BlocProvider.of<TasksetCreateTasklistBloc>(context)
                    .add(EditTaskInTaskList(widget.index, task4Cards));
              }
              Navigator.pop(context);
            }
          },
        ));
  }
}
