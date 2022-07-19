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

class CreateVocabletestScreen extends StatefulWidget {
  final TaskVocableTest? task;

  const CreateVocabletestScreen({Key? key, required this.task}) : super(key: key);
  @override
  CreateVocabletestScreenState createState() => CreateVocabletestScreenState();
}

class CreateVocabletestScreenState extends State<CreateVocabletestScreen> {
  @override
  Widget build(BuildContext context) {
    Taskset blocTaskset = BlocProvider.of<CreateTasksetBloc>(context).taskset!;
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppbar(
        size: screenSize.width / 5,
        titel: "Vokabeltest",
        color: LamaColors.findSubjectColor(blocTaskset.subject ?? "normal"),
      ),
    );
  }
}
