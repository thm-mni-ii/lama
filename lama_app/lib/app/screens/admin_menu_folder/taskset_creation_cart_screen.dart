import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/widgets/custom_appbar.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/input_validation.dart';
import 'package:lama_app/app/bloc/taskset_options_bloc.dart';

import '../../bloc/create_taskset_bloc.dart';
import '../../state/create_taskset_state.dart';
import '../taskset_option_screen.dart';

///This file creates the Taskset Creation Cart Screen
///This Screen provides an option to add a task to the current taskset
///or to generate a JSON from it.
///
///
///{@important} the url given via input should be validated with the
///[InputValidation] to prevent any Issue with Exceptions. However
///in this screen the [InputValidation] is only used to prevent simple issues.
///The connection erros are handelt through the [TasksetOptionsBloc]
///
/// * see also
///    [TasksetCreationCartBloc]
///    [TasksetCreationCartEvent]
///    [TasksetCreationState]
///
/// Author: Handito Bismo, Nico Soethe
/// latest Changes: 09.06.2022
class TasksetCreationCartScreen extends StatefulWidget {
  const TasksetCreationCartScreen() : super();
  @override
  State<StatefulWidget> createState() {
    return TasksetCreationCartScreenState();
  }
}

///OptionTaskScreennState provides the state for the [OptionTaskScreen]
class TasksetCreationCartScreenState extends State<TasksetCreationCartScreen> {
  TasksetCreationCartScreenState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: screenSize/5,
        child: BlocBuilder<CreateTasksetBloc, CreateTasksetState>(
            builder: (context, state) {
              return CustomAppbar(titel: state.taskset.name, size: screenSize.width / 5, color: state.color);
            }),
      ),
      /*appBar: CustomAppbar(
          size: screenSize.width / 5,
          titel: "Tasksetname",
          color: LamaColors.bluePrimary),*/
      body: Column(
        children: [
          Container(
            child: (Expanded(
              child: (Row(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      margin: EdgeInsets.all(25),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                        create: (BuildContext context) =>
                                            TasksetOptionsBloc(),
                                        child: OptionTaskScreen(),
                                      )));
                        },
                        child: const Text("Task hinzufügen"),
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
                                        value:
                                            BlocProvider.of<CreateTasksetBloc>(
                                                context),
                                        child: TasksetCreationCartScreen(),
                                      )));
                        },
                        child: const Text("Taskset generieren"),
                      ),
                    ),
                  ),
                ],
              )),
            )),
          ),
        ],
      ),
      /*body: Padding(
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
                              MaterialPageRoute(builder: (context) => const TasksetCreationListScreen()),
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
                              MaterialPageRoute(builder: (context) => const TasksetCreationListScreen()),
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
      ),*/
    );
  }
}
