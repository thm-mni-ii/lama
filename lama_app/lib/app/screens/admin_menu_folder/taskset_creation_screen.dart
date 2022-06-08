import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/taskset_creation_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_creation_cart_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/widgets/custom_appbar.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
import 'package:lama_app/util/input_validation.dart';
import 'package:lama_app/app/bloc/taskset_options_bloc.dart';

import '../../bloc/taskset_creation_cart_bloc.dart';
import '../taskset_option_screen.dart';


///This file creates the Taskset Creation Screen
///This Screen provides all needed input forms to create a taskset object.
///
/// * see also
///    [TasksetCreationBloc]
///    [TasksetCreationEvent]
///    [TasksetCreationState]
///
/// author: Nico Soethe
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
  ///{@return} [Widget] decided by the incoming state of the [TasksetCreationBloc]
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
      appBar: CustomAppbar(size: screenSize.width/5, titel: "Taskset erstellen", color:  LamaColors.bluePrimary),
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
                        create: (BuildContext context) => TasksetCreationCartBloc(),
                        child: TasksetCreationCartScreen(),
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
}
