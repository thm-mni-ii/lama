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
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            urlInitValue = null;
            ScaffoldMessenger.of(context).showSnackBar(_saveSuccess(context));
            context.read<TasksetOprionsBloc>().add(TasksetOptionsReload());
          }
          if (state is TasksetOptionsPushFailed) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            urlInitValue = state.failedUrl;
            ScaffoldMessenger.of(context)
                .showSnackBar(_saveFailed(context, state.error));
            context.read<TasksetOprionsBloc>().add(TasksetOptionsReload());
          }
          if (state is TasksetOptionsDeleteSuccess) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(_deleteSuccess(context));
            context.read<TasksetOprionsBloc>().add(TasksetOptionsReload());
          }
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
            Text(
              urls[index].url.length > 30
                  ? urls[index].url.substring(7, 32) + '...'
                  : urls[index].url,
              style: LamaTextTheme.getStyle(
                  color: LamaColors.black, fontSize: 18, monospace: true),
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

  Widget _deleteSuccess(BuildContext context) {
    return SnackBar(
      duration: Duration(seconds: 1, milliseconds: 0),
      content: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(5),
            child: Icon(
              Icons.delete_forever_rounded,
              size: 25,
              color: LamaColors.white,
            ),
          ),
          Text(
            'URL erfolgreich gelöscht!',
            style: LamaTextTheme.getStyle(fontSize: 14),
          ),
        ],
      ),
      backgroundColor: LamaColors.redAccent,
    );
  }

  Widget _saveSuccess(BuildContext context) {
    return SnackBar(
      duration: Duration(seconds: 1, milliseconds: 0),
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

  Widget _saveFailed(BuildContext context, String error) {
    return SnackBar(
      duration: Duration(seconds: 1, milliseconds: 0),
      content: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(5),
            child: Icon(
              Icons.close_rounded,
              size: 25,
              color: LamaColors.white,
            ),
          ),
          Text(
            error,
            style: LamaTextTheme.getStyle(fontSize: 14),
          ),
        ],
      ),
      backgroundColor: LamaColors.redAccent,
    );
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
