import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/event/create_taskset_event.dart';
import 'package:lama_app/app/repository/taskset_repository.dart';
import 'package:lama_app/app/screens/admin_menu_folder/bloc/taskset_create_tasklist_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_creation_card/screens/taskset_creation_cart_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/widgets/custom_appbar.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:lama_app/util/LamaColors.dart';

///This file creates the Taskset Creation Screen
///This Screen provides all needed input forms to create a taskset object.
///
/// * see also
///    [TasksetCreationBloc]
///    [TasksetCreationEvent]
///    [TasksetCreationState]
///
/// author(s): Handito Bismo, Nico Soethe, Tim Steinmüller
/// latest Changes: 08.06.2022
class TasksetCreationScreen extends StatefulWidget {
  const TasksetCreationScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => TasksetCreationScreenState();
}

///TasksetCreationScreenState provides the state for the [TasksetCreationScreen]
class TasksetCreationScreenState extends State<TasksetCreationScreen> {
  String? _currentSelectedGrade;
  String? _currentSelectedSubject;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  bool first = true;

  Taskset buildWholeTaskset(Taskset? blocTaskset) {
    if (blocTaskset != null && _currentSelectedSubject != blocTaskset.subject) {
      BlocProvider.of<TasksetCreateTasklistBloc>(context).taskList.clear();
    }
    Taskset taskset = Taskset(
      _nameController.text,
      _currentSelectedSubject,
      _descriptionController.text,
      int.parse(_currentSelectedGrade!),
    );
    taskset.tasks = blocTaskset != null ? blocTaskset.tasks : [];
    //taskset.taskurl = TaskUrl(url: "");
    return taskset;
  }

  ///override build methode [StatelessWidget]
  ///
  ///{@param} [BuildContext] as context
  ///
  ///{@return} [Widget] decided by the incoming state of the [CreateTasksetBloc]
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CreateTasksetBloc>(context);
    Taskset? blocTaskset = bloc.taskset;
    Size screenSize = MediaQuery.of(context).size;
    TasksetRepository tasksetRepo =
        RepositoryProvider.of<TasksetRepository>(context);

    if (blocTaskset != null && first) {
      _currentSelectedGrade = blocTaskset.grade.toString();
      _currentSelectedSubject = blocTaskset.subject;
      _nameController.text = blocTaskset.name!;
      _descriptionController.text = blocTaskset.description ?? "";

      first = false;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppbar(
        size: screenSize.width / 5,
        titel: "Taskset erstellen",
        color: LamaColors.findSubjectColor(_currentSelectedSubject ?? "normal"),
      ),
      body: Column(
        // body kann auch setupTasksetBody sein aber dann farb probleme
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.only(left: 15, right: 15, top: 15),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    alignment: Alignment.centerLeft,
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(hintText: "Tasksetname"),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    alignment: Alignment.centerLeft,
                    child: TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(hintText: "Kurzbeschreibung"),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 45),
                    alignment: Alignment.centerLeft,
                    child: const Text.rich(
                      TextSpan(
                        text: 'Klasse',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // möglicher weise auch in block => statelesswidget
                  DropdownButtonFormField<String>(
                    hint: Text("Klassenstufe auswählen"),
                    value: _currentSelectedGrade,
                    isDense: true,
                    onChanged: (String? newValue) {
                      setState(() => _currentSelectedGrade = newValue);
                    },
                    items: tasksetRepo.klassenStufe.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  DropdownButtonFormField<String>(
                    hint: const Text("Fach auswählen"),
                    value: _currentSelectedSubject,
                    isDense: true,
                    onChanged: (String? newValue) {
                      setState(() => _currentSelectedSubject = newValue);
                    },
                    items: tasksetRepo.subjectList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.all(25),
              child: ElevatedButton(
                onPressed: () {
                  if (_nameController.text.isNotEmpty &&
                      _currentSelectedGrade != null &&
                      _currentSelectedSubject != null) {
                    // initilize everything else in taskset
                    bloc.add(EditTaskset(buildWholeTaskset(blocTaskset)));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(value: bloc),
                            BlocProvider(
                              create: (context) => TasksetCreateTasklistBloc(
                                blocTaskset == null ||
                                        blocTaskset.subject !=
                                            _currentSelectedSubject
                                    ? []
                                    : blocTaskset.tasks!,
                              ),
                            ),
                          ],
                          child: TasksetCreationCartScreen(
                            isEdit: !first,
                            editedTaskset: blocTaskset,
                          ),
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: LamaColors.redAccent,
                        content: const Text(
                          'Fülle alle Felder aus',
                          textAlign: TextAlign.center,
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                },
                child: const Text("Weiter"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
