import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/tasksets_name_screen.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
import 'package:lama_app/util/input_validation.dart';
import 'package:lama_app/app/bloc/taskset_options_bloc.dart';
import 'package:lama_app/app/event/taskset_options_event.dart';
import 'package:lama_app/app/model/taskUrl_model.dart';

import '../../bloc/user_selection_bloc.dart';
import '../user_selection_screen.dart';

//This class is for TasksetErstellenScreen.
//In this class, the teacher should be able to create a list of tasksets and save it to the server.
//The teacher have the option to name the taskset in text field Tasksetname and the description in Kurzbeschreibung.
class LehrerTasksetsErstellenScreen extends StatefulWidget {
  final BoxConstraints constraints;

  const LehrerTasksetsErstellenScreen({Key key, this.constraints})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return LehrerTasksetsErstellenScreenState(constraints);
  }
}

///OptionTaskScreennState provides the state for the [OptionTaskScreen]
class LehrerTasksetsErstellenScreenState
    extends State<LehrerTasksetsErstellenScreen> {
  //[_formKey] should be used to identify every Form in this Screen
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final BoxConstraints constraints;

  LehrerTasksetsErstellenScreenState(this.constraints);

  @override
  void initState() {
    super.initState();
  }

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

    var facher = ["Mathe", "Deutsch", "Englisch", "Sachkunde"];
    Size screenSize = MediaQuery.of(context).size;
    var _currentSelectedValue;
    var _currentSelectedValue2;
    return Scaffold(
      appBar: navBar(
          screenSize.width / 5, 'Tasksets erstellen', LamaColors.bluePrimary),
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
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Tasksetname',
                          ),
                          onSaved: null,
                          validator: null,
                        )),
                    Divider(),
                    Container(
                        margin: EdgeInsets.only(top: 15),
                        alignment: Alignment.centerLeft,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Kurzbeschreibung',
                          ),
                          onSaved: null,
                          validator: null,
                        )),
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
                            errorStyle: TextStyle(
                                color: Colors.redAccent, fontSize: 16.0),
                            hintText: 'Klassenstufe auswählen',
                          ),
                          isEmpty: _currentSelectedValue == '',
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _currentSelectedValue,
                              isDense: true,
                              onChanged: (String newValue) {
                                setState(() {
                                  _currentSelectedValue = newValue;
                                });
                              },
                              items: klassenStufe.map((String value) {
                                return DropdownMenuItem<String>(
                                    value: value, child: Text(value));
                              }).toList(),
                            ),
                          )),
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
                            errorStyle: TextStyle(
                                color: Colors.redAccent, fontSize: 16.0),
                            hintText: 'Fach auswählen',
                          ),
                          isEmpty: _currentSelectedValue2 == '',
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _currentSelectedValue2,
                              isDense: true,
                              onChanged: (String newValue) {
                                setState(() {
                                  _currentSelectedValue2 = newValue;
                                });
                              },
                              items: facher.map((String value) {
                                return DropdownMenuItem<String>(
                                    value: value, child: Text(value));
                              }).toList(),
                            ),
                          )),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 50),
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const TasksetsNameScreen()),
                            );
                          },
                          child: Text.rich(
                            TextSpan(
                                text: 'Weiter',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        )),
                  ],
                )
              ],
            ),
          ),
          //Items
        ],
      ),
    );
  }

  Widget navBar(double size, String titel, Color colors) {
    return AppBar(
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (BuildContext context) => UserSelectionBloc(),
                    child: UserSelectionScreen(),
                  ),
                ),
              );
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ),
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
