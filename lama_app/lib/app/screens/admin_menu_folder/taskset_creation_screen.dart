import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/event/create_taskset_event.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_creation_cart_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/widgets/custom_appbar.dart';
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
  final BoxConstraints constraints;

  const TasksetCreationScreen({Key key, this.constraints}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return TasksetCreationScreenState(constraints);
  }
}

///TasksetCreationScreenState provides the state for the [TasksetCreationScreen]
class TasksetCreationScreenState extends State<TasksetCreationScreen> {
  //[_formKey] should be used to identify every Form in this Screen
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _currentSelectedValue;
  var _currentSelectedValue2;
  final BoxConstraints constraints;

  TasksetCreationScreenState(this.constraints);

  @override
  void initState() {
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

    var klassenStufe = [
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
    ];

    var facher = ["Mathe", "Deutsch", "Englisch", "Sachkunde"];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppbar(
        size: screenSize.width/5,
        titel: "Taskset erstellen",
        color: LamaColors.bluePrimary,
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
                      decoration: InputDecoration(hintText: "Tasksetname"),
                      onChanged: (value) => context
                          .read<CreateTasksetBloc>()
                          .add(CreateTasksetChangeName(value)),
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
                    child: Text.rich(
                      TextSpan(
                        text: 'Klasse',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 16.0),
                        hintText: 'Klassenstufe auswählen',
                      ),
                      isEmpty: _currentSelectedValue == '',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: Text("Klassenstufe auswählen"),
                          value: _currentSelectedValue,
                          isDense: true,
                          onChanged: (String newValue) => {
                            setState(() => _currentSelectedValue = newValue),
                            context.read<CreateTasksetBloc>().add(
                                CreateTasksetChangeGrade(int.parse(newValue)))
                          },
                          items: klassenStufe.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: InputDecorator(
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                              color: Colors.redAccent, fontSize: 16.0),
                          hintText: '',
                        ),
                        isEmpty: _currentSelectedValue2 == '',
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: Text("Fach auswählen"),
                            value: _currentSelectedValue2,
                            isDense: true,
                            onChanged: (String newValue) => {
                              setState(() {
                                _currentSelectedValue2 = newValue;
                              }),
                              context
                                  .read<CreateTasksetBloc>()
                                  .add(CreateTasksetChangeSubject(newValue))
                            },
                            items: facher.map((String value) {
                              return DropdownMenuItem<String>(
                                  value: value, child: Text(value));
                            }).toList(),
                          ),
                        )),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<CreateTasksetBloc>(context),
                        child: TasksetCreationCartScreen(),
                      ),
                    ),
                  );
                },
                child: const Text("Weiter"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor(String subject) {
    if (subject == "Deutsch") {
      return LamaColors.redPrimary;
    }
  }
}
