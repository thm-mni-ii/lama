import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/widgets/setup_taskset_body.dart';


class NewTasksets extends StatelessWidget {
  const NewTasksets({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (BuildContext context) => CreateTasksetBloc(),
      child: SetupTasksetBody(),
    ); /*TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (BuildContext context) => TasksetOptionsBloc(),
                      child: OptionTaskScreen(),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Taskset importieren",
                    style: TextStyle(color: LamaColors.bluePrimary),
                  ),
                ),
              ),*/
  }
}
