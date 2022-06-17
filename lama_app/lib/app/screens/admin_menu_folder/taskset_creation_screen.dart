import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/event/create_taskset_event.dart';
import 'package:lama_app/app/repository/taskset_repository.dart';
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
/// author(s): Handito Bismo, Nico Soethe
/// latest Changes: 08.06.2022
class TasksetCreationScreen extends StatefulWidget {
  const TasksetCreationScreen({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => TasksetCreationScreenState();
}

///TasksetCreationScreenState provides the state for the [TasksetCreationScreen]
class TasksetCreationScreenState extends State<TasksetCreationScreen> {
  String _currentSelectedGrade;
  String _currentSelectedSubject;

  TextEditingController _nameController = TextEditingController();

  bool first = true;

  Taskset buildWholeTaskset(Taskset blocTaskset) {
    Taskset taskset = Taskset(
      _nameController.text,
      _currentSelectedSubject,
      int.parse(_currentSelectedGrade),
    );
    taskset.tasks = blocTaskset != null ? blocTaskset.tasks : [];
    return taskset;
  }

  @override
  void initState() {
    BlocProvider.of<CreateTasksetBloc>(context).add(FlushTaskset());
    super.initState();
  }

  ///override build methode [StatelessWidget]
  ///
  ///{@param} [BuildContext] as context
  ///
  ///{@return} [Widget] decided by the incoming state of the [CreateTasksetBloc]
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Taskset blocTaskset = BlocProvider.of<CreateTasksetBloc>(context).taskset;
    TasksetRepository tasksetRepo =
        RepositoryProvider.of<TasksetRepository>(context);

    if (blocTaskset != null && first) {
      _currentSelectedGrade = blocTaskset.grade.toString();
      _currentSelectedSubject = blocTaskset.subject;
      _nameController.text = blocTaskset.name;

      first = false;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppbar(
        size: screenSize.width/5,
        titel: "Taskset erstellen",
        color: LamaColors.findSubjectColor(_currentSelectedSubject ?? "normal"),
      ),
      body: Column(
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
                  DropdownButtonFormField<String>(
                    hint: Text("Klassenstufe auswählen"),
                    value: _currentSelectedGrade,
                    isDense: true,
                    onChanged: (String newValue) {
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
                    onChanged: (String newValue) {
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
                  // TODO state comit wenn erfolgreich in nächsten screen wenn nicht snackbar anzeigen
                  if (_nameController.text.isNotEmpty &&
                      _currentSelectedGrade != null &&
                      _currentSelectedSubject != null) {
                    // initilize everything else in taskset
                    BlocProvider.of<CreateTasksetBloc>(context).add(
                      EditTaskset(
                        buildWholeTaskset(blocTaskset),
                      ),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TasksetCreationCartScreen(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: LamaColors.redAccent,
                        content: Text(
                          'Fülle alle Felder aus',
                          textAlign: TextAlign.center,
                          //style: LamaTextTheme.getStyle(fontSize: 15),
                        ),
                        duration: Duration(seconds: 1),
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
