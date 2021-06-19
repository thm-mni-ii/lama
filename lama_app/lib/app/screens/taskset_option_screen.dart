import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/taskset_options_bloc.dart';
import 'package:lama_app/app/event/taskset_options_event.dart';
import 'package:lama_app/app/model/taskUrl_model.dart';
import 'package:lama_app/app/repository/taskset_repository.dart';
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
  String urlInitValue;
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
            urlInitValue = null;
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(_saveSuccess());
          }
          if (state is TasksetOptionsPushFailed) {
            urlInitValue = state.failedUrl;
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context)
                .showSnackBar(_saveFailed(state.error));
          }
          if (state is TasksetOptionsDeleteSuccess) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(_deleteSuccess());
          }
          if (state is TasksetOptionsUrlSelected) {
            print('TasksetOptionsUrlSelected ALERT!');
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text('Taskset URL'),
                content: SingleChildScrollView(child: Text(state.url)),
                actions: [
                  TextButton(
                    child: Text('Schließen'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          }
          //context.read<TasksetOprionsBloc>().add(TasksetOptionsReload());
        },
        child: BlocBuilder<TasksetOprionsBloc, TasksetOptionsState>(
          builder: (context, state) {
            if (state is TasksetOptionsDefault) {
              return Padding(
                padding: EdgeInsets.all(20),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Icon(
                      Icons.add_link,
                      color: LamaColors.bluePrimary,
                      size: 30,
                    ),
                    _inputFields(context, urlInitValue),
                    _headline('Taskset URLs'),
                    _tasksetUrlList(state.urls),
                    _headline('Kürzlich gelöscht'),
                    _tasksetUrlDeletedList(state.deletedUrls),
                  ],
                ),
              );
            }
            context.read<TasksetOprionsBloc>().add(TasksetOptionsReload());
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _inputFields(BuildContext context, String initValue) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            initialValue: initValue,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: 'Taskset URL',
              hintText: 'https://beispiel.de/taskset.json',
            ),
            onChanged: (value) => {
              context
                  .read<TasksetOprionsBloc>()
                  .add(TasksetOptionsChangeURL(value))
            },
            validator: (value) => InputValidation.inputURLValidation(value),
            onFieldSubmitted: (value) => {
              if (_formKey.currentState.validate())
                context
                    .read<TasksetOprionsBloc>()
                    .add(TasksetOptionsPush(context))
            },
          ),
        ],
      ),
    );
  }

  Widget _tasksetUrlList(List<TaskUrl> urls) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: urls.length,
      itemBuilder: (context, index) {
        return Row(
          children: [
            TextButton(
              child: Text(
                urls[index].url.length > 30
                    ? urls[index].url.substring(7, 32) + '...'
                    : urls[index].url,
                style: LamaTextTheme.getStyle(
                    color: LamaColors.black, fontSize: 18, monospace: true),
              ),
              onPressed: () {
                context
                    .read<TasksetOprionsBloc>()
                    .add(TasksetOptionsSelectUrl(urls[index]));
              },
            ),
            Spacer(),
            IconButton(
              icon: Icon(
                Icons.delete_forever_rounded,
                color: LamaColors.redAccent,
                size: 25,
              ),
              onPressed: () {
                context.read<TasksetOprionsBloc>().add(TasksetOptionsDelete(
                    urls[index],
                    RepositoryProvider.of<TasksetRepository>(context)));
              },
            )
          ],
        );
      },
    );
  }

  Widget _tasksetUrlDeletedList(List<TaskUrl> urls) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: urls.length,
      itemBuilder: (context, index) {
        return Row(
          children: [
            Text(
              urls[index].url.length > 30
                  ? urls[index].url.substring(7, 32) + '...'
                  : urls[index].url,
              style: LamaTextTheme.getStyle(
                  color: Colors.grey, fontSize: 18, monospace: true),
            ),
            Spacer(),
            IconButton(
              icon: Icon(
                Icons.replay_rounded,
                color: LamaColors.bluePrimary,
                size: 25,
              ),
              onPressed: () {
                context
                    .read<TasksetOprionsBloc>()
                    .add(TasksetOptionsPushUrl(urls[index]));
              },
            )
          ],
        );
      },
    );
  }

  Widget _deleteSuccess() {
    return _snackbar(Icons.delete_forever_rounded, 'URL erfolgreich gelöscht!',
        LamaColors.redAccent);
  }

  Widget _saveSuccess() {
    return _snackbar(
        Icons.check_rounded, 'Änderung erfogreich!', LamaColors.greenPrimary);
  }

  Widget _saveFailed(String error) {
    return _snackbar(Icons.close_rounded, error, LamaColors.redAccent);
  }

  Widget _headline(String headline) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(top: 20),
        child: Text(
          headline,
          style: LamaTextTheme.getStyle(
            fontSize: 12,
            color: LamaColors.bluePrimary,
          ),
        ),
      ),
    );
  }

  Widget _snackbar(IconData icon, String msg, Color color) {
    return SnackBar(
      duration: Duration(seconds: 1, milliseconds: 0),
      content: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(5),
            child: Icon(
              icon,
              size: 25,
              color: LamaColors.white,
            ),
          ),
          Text(
            msg,
            style: LamaTextTheme.getStyle(fontSize: 14),
          ),
        ],
      ),
      backgroundColor: color,
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
