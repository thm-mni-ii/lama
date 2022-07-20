import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/event/create_taskset_event.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_choose_task/screens/taskset_choose_task_screen.dart';
import 'package:lama_app/app/screens/admin_menu_folder/widgets/custom_appbar.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/key_generator.dart';

class CreateFourCardsScreen extends StatefulWidget {
  final Task4Cards? task;

  const CreateFourCardsScreen({Key? key, required this.task}) : super(key: key);
  @override
  CreateFourCardsScreenState createState() => CreateFourCardsScreenState();
}

class CreateFourCardsScreenState extends State<CreateFourCardsScreen> {
  TextEditingController _rewardController = TextEditingController();
  TextEditingController _questionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Taskset blocTaskset = BlocProvider.of<CreateTasksetBloc>(context).taskset!;
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppbar(
        size: screenSize.width / 5,
        titel: "Four Cards",
        color: LamaColors.findSubjectColor(blocTaskset.subject ?? "normal"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(5),
                child: Column(
                  children: [
                        Container(
                          margin: EdgeInsets.only(top: 30, left: 5, right: 5),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Frage",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5, right: 5),
                          child: TextFormField(
                            controller: _questionController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: 'Gib die Frage an',
                            ),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return "Die Frage fehlt!";
                              }
                              return null;
                            },
                            onSaved: (String? text) =>
                                _questionController.text = text!,
                          ),
                        ),  
                        Container(
                          margin: EdgeInsets.only(top: 30, left: 5, right: 5),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Erreichbare Lamacoins",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5, right: 5),
                          child: TextFormField(
                            controller: _rewardController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Erreichbare Lamacoins',
                            ),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return "Beitrag fehlt!";
                              }
                              return null;
                            },
                            onSaved: (String? text) =>
                                _rewardController.text = text!,
                          ),
                        ),
                  ],
                ),
              ),
            ),
          )
        ],
      )
    );
  }
}
