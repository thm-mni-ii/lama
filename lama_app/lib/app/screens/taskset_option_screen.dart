import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/taskset_options_bloc.dart';
import 'package:lama_app/app/event/taskset_options_event.dart';
import 'package:lama_app/app/model/taskUrl_model.dart';
import 'package:lama_app/app/state/taskset_options_state.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
import 'package:lama_app/util/input_validation.dart';

class OptionTaskScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OptionTaskScreennState();
  }
}

class OptionTaskScreennState extends State<OptionTaskScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
          if (state is TasksetOptionsPushSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(_saveSuccess(context));
            context.read<TasksetOprionsBloc>().add(TasksetOptionsReload());
          }
        },
        child: BlocBuilder<TasksetOprionsBloc, TasksetOptionsState>(
          builder: (context, state) {
            if (state is TasksetOptionsDefault) {
              return Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    _inputFields(context),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          'Taskset URLs',
                          style: LamaTextTheme.getStyle(
                            fontSize: 12,
                            color: LamaColors.bluePrimary,
                          ),
                        ),
                      ),
                    ),
                    _tasksetUrlList(state.urls)
                  ],
                ),
              );
            }
            context.read<TasksetOprionsBloc>().add(TasksetOptionsReload());
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
      floatingActionButton: _userOptionsButtons(context),
    );
  }

  Widget _inputFields(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Taskset URL',
              hintText: 'https://beispiel.de/taskset.json',
              suffixIcon: Icon(Icons.add_link),
            ),
            onChanged: (value) => {
              context
                  .read<TasksetOprionsBloc>()
                  .add(TasksetOptionsChangeURL(value))
            },
          ),
        ],
      ),
    );
  }

  Widget _tasksetUrlList(List<TaskUrl> urls) {
    return Expanded(
      child: ListView.builder(
        itemCount: urls.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Text(
                urls[index].url,
                style: LamaTextTheme.getStyle(
                    color: LamaColors.black, fontSize: 18, monospace: true),
              ),
              Spacer(),
              IconButton(
                  icon: Icon(
                    Icons.delete_forever_rounded,
                    color: LamaColors.redAccent,
                    size: 30,
                  ),
                  onPressed: () {})
            ],
          );
        },
      ),
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
                  if (_formKey.currentState.validate())
                    context
                        .read<TasksetOprionsBloc>()
                        .add(TasksetOptionsPush());
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
