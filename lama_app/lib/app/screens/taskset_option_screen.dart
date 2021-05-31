import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/taskset_options_bloc.dart';
import 'package:lama_app/app/event/taskset_options_event.dart';
import 'package:lama_app/app/state/taskset_options_state.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

class OptionTaskScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OptionTaskScreennState();
  }
}

class OptionTaskScreennState extends State<OptionTaskScreen> {
  //GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _bar(screenSize.width / 5),
      body: BlocListener(
        bloc: BlocProvider.of<TasksetOprionsBloc>(context),
        listener: (context, state) {
          if (state is TasksetOptionsPushSuccess)
            ScaffoldMessenger.of(context).showSnackBar(_saveSuccess(context));
        },
        child: BlocBuilder<TasksetOprionsBloc, TasksetOptionsState>(
          builder: (context, state) {
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
      floatingActionButton: _userOptionsButtons(context),
    );
  }

  Widget _saveSuccess(BuildContext context) {
    return SnackBar(
      content: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(5),
            child: Icon(
              Icons.check_rounded,
              size: 25,
              color: LamaColors.white,
            ),
          ),
          Text(
            'Änderung erfogreich!',
            style: LamaTextTheme.getStyle(fontSize: 14),
          ),
        ],
      ),
      backgroundColor: LamaColors.greenPrimary,
    );
  }

  Widget _userOptionsButtons(BuildContext context) {
    return Row(
      children: [
        Padding(
            padding: EdgeInsets.only(right: 10),
            child: Ink(
              decoration: ShapeDecoration(
                color: LamaColors.greenAccent,
                shape: CircleBorder(),
              ),
              padding: EdgeInsets.all(7.0),
              child: IconButton(
                icon: Icon(Icons.check_rounded),
                color: Colors.white,
                tooltip: 'Bestätigen',
                onPressed: () {
                  //if (_formKey.currentState.validate())
                  context.read<TasksetOprionsBloc>().add(TasksetOptionsPush());
                },
              ),
            )),
        Ink(
          decoration: ShapeDecoration(
            color: LamaColors.redPrimary,
            shape: CircleBorder(),
          ),
          padding: EdgeInsets.all(2.0),
          child: IconButton(
            icon: Icon(Icons.close_rounded),
            color: Colors.white,
            tooltip: 'Abbrechen',
            onPressed: () {
              context
                  .read<TasksetOprionsBloc>()
                  .add(TasksetOptionsAbort(context));
            },
          ),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.end,
    );
  }

  Widget _bar(double size) {
    return AppBar(
      title: Text(
        'Aufgabenverwaltung',
        style: LamaTextTheme.getStyle(fontSize: 18),
      ),
      toolbarHeight: size,
      backgroundColor: LamaColors.bluePrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
    );
  }
}
