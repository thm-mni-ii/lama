import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_creation_list_screen.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
import 'package:lama_app/util/input_validation.dart';
import 'package:lama_app/app/bloc/taskset_options_bloc.dart';
import 'package:lama_app/app/event/taskset_options_event.dart';
import 'package:lama_app/app/model/taskUrl_model.dart';

import '../../bloc/taskset_creation_bloc.dart';
import '../../bloc/taskset_creation_list_bloc.dart';
import '../../bloc/user_selection_bloc.dart';
import '../taskset_option_screen.dart';
import '../user_selection_screen.dart';


///This file creates the Taskset Option Screen
///This Screen provides an option to store an link
///which provides tasksets as json.
///
///
///{@important} the url given via input should be validated with the
///[InputValidation] to prevent any Issue with Exceptions. However
///in this screen the [InputValidation] is only used to prevent simple issues.
///The connection erros are handelt through the [TasksetOptionsBloc]
///
/// * see also
///    [TasksetOptionsBloc]
///    [TasksetOptionsEvent]
///    [TasksetOptionsState]
///
/// Author: L.Kammerer
/// latest Changes: 15.07.2021
class TasksetCreationScreen extends StatefulWidget {
  final BoxConstraints constraints;

  const TasksetCreationScreen({Key key, this.constraints}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return TasksetCreationScreenState(constraints);
  }
}

///OptionTaskScreennState provides the state for the [OptionTaskScreen]
class TasksetCreationScreenState extends State<TasksetCreationScreen> {
  //[_formKey] should be used to identify every Form in this Screen
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //temporary url to prevent losing the url on error states
  String urlInitValue;
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
  ///{@return} [Widget] decided by the incoming state of the [TasksetOptionsBloc]
  @override
  Widget build(BuildContext context) {
    var klassenStufe = [
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
    ];

    var facher = [
      "Mathe",
      "Deutsch",
      "Englisch",
      "Sachkunde"
    ];
    Size screenSize = MediaQuery.of(context).size;
    var _currentSelectedValue;
    var _currentSelectedValue2;
    return Scaffold(
      appBar: _bar(screenSize.width/5, "Taskset erstellen", LamaColors.bluePrimary),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child:
            Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text.rich(
                    TextSpan(
                        text: 'Tasksetname',
                        style: TextStyle(
                          fontSize: 16,
                        )),
                  ),
                ),
                Divider(),

                Container(
                  margin: EdgeInsets.only(top: 15),
                  alignment: Alignment.centerLeft,
                  child: Text.rich(
                    TextSpan(
                        text: 'Kurzbeschreibung',
                        style: TextStyle(
                          fontSize: 16,
                        )),
                  ),
                ),
                Divider(),

                Container(
                  margin: EdgeInsets.only(top: 45),
                  alignment: Alignment.centerLeft,
                  child: Text.rich(
                    TextSpan(
                        text: 'Klassenstufe',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),

                Container(
                  child: InputDecorator(
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                        hintText: 'Klassenstufe auswählen',
                      ),
                      isEmpty: _currentSelectedValue == '',
                      child: DropdownButtonHideUnderline(
                        child:
                        DropdownButton<String>(
                          value: _currentSelectedValue,
                          isDense: true,
                          onChanged: (String newValue){
                            setState(() {
                              _currentSelectedValue = newValue;
                            });
                          },
                          items: klassenStufe.map((String value){
                            return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value)
                            );
                          }).toList(),
                        ),)
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 15),
                  alignment: Alignment.centerLeft,
                  child: Text.rich(
                    TextSpan(
                        text: 'Fach',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),

                Container(
                  child: InputDecorator(
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                        hintText: 'Fach auswählen',
                      ),
                      isEmpty: _currentSelectedValue2 == '',
                      child: DropdownButtonHideUnderline(
                        child:
                        DropdownButton<String>(
                          value: _currentSelectedValue2,
                          isDense: true,
                          onChanged: (String newValue){
                            setState(() {
                              _currentSelectedValue2 = newValue;
                            });
                          },
                          items: facher.map((String value){
                            return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value)
                            );
                          }).toList(),
                        ),)
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.all(25),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (BuildContext context) => TasksetCreationListBloc(),
                        child: TasksetCreationListScreen(),
                      )
                  ));
                },
                child: const Text("Weiter"),
              ),
            ),
          ),
            ],
          )
        );
    /*return Scaffold(
      appBar: _bar(screenSize.width / 5, 'Tasksets erstellen', LamaColors.bluePrimary),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            // create space between each childs
            child: Stack(
              children: [
                 Column(
                    children: [

                      Container(
                      alignment: Alignment.centerLeft,
                      child: Text.rich(
                        TextSpan(
                            text: 'Tasksetname',
                            style: TextStyle(
                              fontSize: 16,
                            )),
                        ),
                      ),
                 Divider(),

                      Container(
                      margin: EdgeInsets.only(top: 15),
                      alignment: Alignment.centerLeft,
                      child: Text.rich(
                        TextSpan(
                            text: 'Kurzbeschreibung',
                            style: TextStyle(
                              fontSize: 16,
                            )),
                      ),
                 ),
                 Divider(),

                      Container(
                        margin: EdgeInsets.only(top: 45),
                        alignment: Alignment.centerLeft,
                        child: Text.rich(
                        TextSpan(
                            text: 'Klassenstufe',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      ),

                      Container(
                        child: InputDecorator(
                          decoration: InputDecoration(
                            errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                            hintText: 'Klassenstufe auswählen',
                            ), 
                          isEmpty: _currentSelectedValue == '',
                          child: DropdownButtonHideUnderline(  
                            child: 
                              DropdownButton<String>(
                                value: _currentSelectedValue,
                                isDense: true,
                                onChanged: (String newValue){
                                  setState(() {
                                    _currentSelectedValue = newValue;
                                  });
                                },
                                items: klassenStufe.map((String value){
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value)
                              );
                              }).toList(),
                        ),)
                          ),
                        ),

                        Container(
                        margin: EdgeInsets.only(top: 15),
                        alignment: Alignment.centerLeft,
                        child: Text.rich(
                        TextSpan(
                            text: 'Fach',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      ),

                        Container(
                        child: InputDecorator(
                          decoration: InputDecoration(
                            errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                            hintText: 'Fach auswählen',
                            ), 
                          isEmpty: _currentSelectedValue2 == '',
                          child: DropdownButtonHideUnderline(  
                            child: 
                              DropdownButton<String>(
                                value: _currentSelectedValue2,
                                isDense: true,
                                onChanged: (String newValue){
                                  setState(() {
                                    _currentSelectedValue2 = newValue;
                                  });
                                },
                                items: facher.map((String value){
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value)
                              );
                              }).toList(),
                        ),)
                          ),
                        ),

                        Container(
                        margin: EdgeInsets.only(top: 50),
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: null,
                          child: Text.rich(
                                TextSpan(
                                  text: 'Weiter',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                            )),
                      ),
                        )
                        
                      ),
                 ],
                )
              ],
            ),
          ),
          //Items
        ],
      ),
    );*/
  }

  ///(private)
  ///porvides [AppBar] with default design for Screens used by the Admin
  ///
  ///{@params}
  ///[AppBar] size as double size
  ///
  ///{@return} [AppBar] with generel AdminMenu specific design
  Widget _bar(double size, String titel, Color colors) {
    return AppBar(
      title: Text(
        titel,
        style: LamaTextTheme.getStyle(fontSize: 18),
      ),
      toolbarHeight: size,
      backgroundColor: colors,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
    );
  }
}
