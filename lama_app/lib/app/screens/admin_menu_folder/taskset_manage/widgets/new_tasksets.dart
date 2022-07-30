import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/bloc/taskset_create_tasklist_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/widgets/setup_taskset_body.dart';

class NewTasksets extends StatelessWidget {
  const NewTasksets({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => CreateTasksetBloc(),
        ),
        BlocProvider(
          create: (context) => TasksetCreateTasklistBloc([]),
        ),
      ],
      child: SetupTasksetBody(),
    );
  }
}
