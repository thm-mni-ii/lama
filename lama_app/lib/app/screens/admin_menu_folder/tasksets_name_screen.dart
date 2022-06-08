import 'package:flutter/material.dart';
import 'package:lama_app/app/screens/admin_menu_folder/lehrer_taskset_erstellen_screen.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
import 'package:lama_app/util/input_validation.dart';


//This class is for tasksets list interface.
//The idea is, after the teachers created the taskset, they have the option to edit or delete the lists
//In this class, the teachers should be able to see the list of the tasksets in form of Tasksets-Title and Tasksets-Description; and 2 icons (edit,delete)
//Title of the tasksets should be the title of the task type in JSON (4Cards, Equation, Clock, etc)
//and the description should be the description of the task type.

//Author: Handito Bismo

class TasksetsNameScreen extends StatefulWidget {
  final BoxConstraints constraints;

  const TasksetsNameScreen({Key key, this.constraints}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return TasksetsNameScreenState(constraints);
  }
}

///OptionTaskScreennState provides the state for the [OptionTaskScreen]
class TasksetsNameScreenState extends State<TasksetsNameScreen> {
  //[_formKey] should be used to identify every Form in this Screen
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final BoxConstraints constraints;

  TasksetsNameScreenState(this.constraints);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: navBar(screensize.width / 5, 'Tasksets erstellen', LamaColors.bluePrimary),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border.all(color: Colors.blueAccent)
                    ),
                    width: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    Container(
                      child: Column(
                      children:[  
                        Container(
                          margin: EdgeInsets.only(top: 15, left: 5 ),
                          child:
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text('4Cards',
                                  style: TextStyle(
                                    fontSize: 18,
                                )
                                ), 
                              ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 15, top: 8, left: 5 , right: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Wähle aus 4 Antworten die richtige aus',
                                  style: TextStyle(
                                    fontSize: 14,
                                )
                                ), 
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: Colors.blueAccent,
                                    ),

                                    Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: Colors.blueAccent,
                                    ), 
                                  ],
                                  )
                               
                              ),
                            ],
                            )
                              
                        ),
                      ],
                    ),
                    ),
                    ],
                    )
                    
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border.all(color: Colors.blueAccent)
                    ),
                    width: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    Container(
                      child: Column(
                      children:[  
                        Container(
                          margin: EdgeInsets.only(top: 15, left: 5 ),
                          child:
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text('4Cards',
                                  style: TextStyle(
                                    fontSize: 18,
                                )
                                ), 
                              ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 15, top: 8, left: 5 , right: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Wähle aus 4 Antworten die richtige aus',
                                  style: TextStyle(
                                    fontSize: 14,
                                )
                                ), 
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: Colors.blueAccent,
                                    ),

                                    Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: Colors.blueAccent,
                                    ), 
                                  ],
                                  )
                               
                              ),
                            ],
                            )
                              
                        ),
                      ],
                    ),
                    ),
                    ],
                    )
                    
                  ),

                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border.all(color: Colors.blueAccent)
                    ),
                    width: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    Container(
                      child: Column(
                      children:[  
                        Container(
                          margin: EdgeInsets.only(top: 15, left: 5 ),
                          child:
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text('4Cards',
                                  style: TextStyle(
                                    fontSize: 18,
                                )
                                ), 
                              ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 15, top: 8, left: 5 , right: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Wähle aus 4 Antworten die richtige aus',
                                  style: TextStyle(
                                    fontSize: 14,
                                )
                                ), 
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: Colors.blueAccent,
                                    ),

                                    Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: Colors.blueAccent,
                                    ), 
                                  ],
                                  )
                               
                              ),
                            ],
                            )
                              
                        ),
                      ],
                    ),
                    ),
                    ],
                    )
                    
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 150),
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          onPressed: () {
                           Navigator.push(
                            context,
                              MaterialPageRoute(builder: (context) => const TasksetsNameScreen()),
                          );
                          },
                          icon: Icon(
                            Icons.add
                          )
                          ),
                        ),
                        
                      Container(
                        margin: EdgeInsets.only(top: 150),
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: () {
                           Navigator.push(
                            context,
                              MaterialPageRoute(builder: (context) => const TasksetsNameScreen()),
                                );
                              },
                          child: Text.rich(
                                TextSpan(
                                  text: 'Taskset anschauen',
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
          ],
        ),
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
              Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LehrerTasksetsErstellenScreen()),
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
