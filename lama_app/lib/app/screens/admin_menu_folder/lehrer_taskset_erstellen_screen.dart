import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  String? tasksetName;
  String? kurzBeschreibung;

  @override
  LehrerTasksetsErstellenScreenState createState() =>
      LehrerTasksetsErstellenScreenState();
}

///OptionTaskScreennState provides the state for the [OptionTaskScreen]
class LehrerTasksetsErstellenScreenState
    extends State<LehrerTasksetsErstellenScreen> {
  //[_formKey] should be used to identify every Form in this Screen
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? tasksetName;
  String? kurzBeschreibung;
  String? text;
  String? text2;
  String? value;
  String? value2;

  LehrerTasksetsErstellenScreenState();

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
    return Scaffold(
      appBar: navBar(screenSize.width / 5, "Tasksets erstellen",
          LamaColors.bluePrimary) as PreferredSizeWidget?,
      body: Form(
        key: _formKey,
        child: Column(
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
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return "Tasksetname fehlt!";
                              }
                              return null;
                            },
                            onSaved: (text) {
                              tasksetName = text;
                            },
                            onChanged: (text) =>
                                setState(() => this.tasksetName = text),
                          )),
                      Divider(),
                      Container(
                          margin: EdgeInsets.only(top: 15),
                          alignment: Alignment.centerLeft,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Kurzbeschreibung',
                            ),
                            validator: (text2) {
                              if (text2 == null || text2.isEmpty) {
                                return "Tasksetname fehlt!";
                              }
                            },
                            onSaved: (text2) {
                              kurzBeschreibung = text2;
                            },
                            onChanged: (text2) =>
                                setState(() => this.kurzBeschreibung = text2),
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
                            isEmpty: value == '',
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: value,
                                items: klassenStufe.map(buildMenuItem).toList(),
                                onChanged: (value) =>
                                    setState(() => this.value = value),
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
                            isEmpty: value2 == '',
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: value2,
                                items: facher.map(buildMenuItem).toList(),
                                onChanged: (value2) =>
                                    setState(() => this.value2 = value2),
                              ),
                            )),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 10),
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Processing Data')),
                                );
                              }
                              _formKey.currentState?.save();
                              print(tasksetName);
                              print(value);
                              print(value2);
                              print(kurzBeschreibung);
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
          ],
        ),

        //Items
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      );

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
