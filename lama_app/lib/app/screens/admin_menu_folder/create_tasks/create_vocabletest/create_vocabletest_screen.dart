import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/add_vocab_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/screens/add_vocab_screen.dart';
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
import 'package:lama_app/util/pair.dart';

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

  List<TwoTextfields> _fields = [];

  bool randomSide = false;
  List<Pair<String?, String?>> pairs = [];

  bool newTask = true;

  List<String> complete_vocabList = [];
  List<Pair<String?, String?>> scannedPairs = [];
  @override
  Widget build(BuildContext context) {
    if (widget.task != null && newTask) {
      _rewardController.text = widget.task!.reward.toString();
      int controllersLength = widget.task!.vocablePairs.length;
      updateDynamicFields(controllersLength, widget.task!.vocablePairs);
      //updateDynamicFields(complete_vocabList.length, scannedPairs);

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
                        ListTile(
                          title:
                              Text("Foto machen oder Bild aus Galerie wählen"),
                          trailing: Icon(Icons.add),
                          onTap: () async {
                            final List<String> complete_vocabList =
                                await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (BuildContext context) =>
                                      AddVocabBloc(),
                                  child: AddVocabScreen(),
                                ),
                              ),
                            );
                            setState(() {
                              if (complete_vocabList != null)
                                this.complete_vocabList = complete_vocabList;
                              double pairIndex = complete_vocabList.length / 2;

                              for (int i = 0; i < pairIndex; i++) {
                                //throws error if complete_vocabList is uneven number
                                //editing vocabs after scanning doesnt seem to work
                                scannedPairs.add(Pair(
                                    complete_vocabList[i + pairIndex.toInt()],
                                    complete_vocabList[i]));
                              }
                              updateDynamicFields(
                                  scannedPairs.length, scannedPairs);
                              this.scannedPairs = [];
                            });
                          },
                        ),
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
                              randomSide = value!;
                            });
                          },
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
              _controllers.forEach((element) {
                pairs.add(
                    Pair(element.controller1!.text, element.controller2!.text));
              });
              if (_formKey.currentState!.validate()) {
                TaskVocableTest taskMatchCategory = TaskVocableTest(
                  widget.task?.id ??
                      KeyGenerator.generateRandomUniqueKey(blocTaskset.tasks!),
                  TaskType.vocableTest,
                  int.parse(_rewardController.text),
                  "Translate the shown word!",
                  3,
                  pairs,
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

                Navigator.pop(context);
              }
            },
            child: Text(newTask ? "Task hinzufügen" : "verändere Task"),
          ),
        ));
  }

  void updateDynamicFields(
      int controllersLength, List<Pair<String?, String?>> vocablePairs) {
    for (int i = 0; i < controllersLength; i++) {
      TwoControllers twoController = TwoControllers();
      TextEditingController? controller1 = TextEditingController();
      TextEditingController? controller2 = TextEditingController();
      controller1.text = vocablePairs[i].a!;
      controller2.text = vocablePairs[i].b!;
      twoController.controller1 = controller1;
      twoController.controller2 = controller2;
      _controllers.add(twoController);
      _fields.add(TwoTextfields(
        controller1: _controllers
            .where((element) => element.controller1 == controller1)
            .first
            .controller1,
        controller2: _controllers
            .where((element) => element.controller2 == controller2)
            .first
            .controller2,
        index: i,
        labelText1: "Englisch",
        labelText2: "Deutsch",
      ));
    }
  }
}
