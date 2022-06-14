import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/widgets/custom_appbar.dart';
import 'package:lama_app/app/state/create_taskset_state.dart';
import 'package:lama_app/util/LamaColors.dart';

class ChooseTaskScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: new Size.fromHeight(screenSize.width/5),
        child: BlocBuilder<CreateTasksetBloc, CreateTasksetState>(
            builder: (context, state) {
              return CustomAppbar(titel: state.taskset.name, size: screenSize.width/5, color: state.color);
            }),
      ),
      body: ListView(
        children: [
          _card()
        ],
      ),
    );
  }

  Widget _card() {
    return BlocBuilder<CreateTasksetBloc, CreateTasksetState>(
      builder: (context, state) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            color: LamaColors.bluePrimary,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    "MoneyTask",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
      }
    );
  }
}