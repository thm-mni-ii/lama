import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/widgets/custom_appbar.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:lama_app/util/LamaColors.dart';

class CreateMarkWordsScreen extends StatefulWidget {
  final int? index;
  final TaskMarkWords? task;

  const CreateMarkWordsScreen({Key? key, required this.index, required this.task}) : super(key: key);
  @override
  CreateMarkWordsScreenState createState() => CreateMarkWordsScreenState();
}

class CreateMarkWordsScreenState extends State<CreateMarkWordsScreen> {
  @override
  Widget build(BuildContext context) {
    Taskset blocTaskset = BlocProvider.of<CreateTasksetBloc>(context).taskset!;
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppbar(
        size: screenSize.width / 5,
        titel: "Mark Words",
        color: LamaColors.findSubjectColor(blocTaskset.subject ?? "normal"),
      ),
    );
  }
}
