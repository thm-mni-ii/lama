import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//Lama default
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
import 'package:lama_app/util/input_validation.dart';
import 'package:lama_app/app/state/taskset_options_state.dart';
//Blocs
import 'package:lama_app/app/bloc/taskset_options_bloc.dart';
//Events
import 'package:lama_app/app/event/taskset_options_event.dart';
import 'package:lama_app/app/model/taskUrl_model.dart';
//States

///This file creates the Taskset Option Screen
///This Screen provides an option to store an link
///which provides tasksets as json.
///
///
///{@important} the url given via input should be validated with the
///[InputValidation] to prevent any Issue with Exceptions. However
///in this screen the [InputValidation] is only used to prevent simple issues.
///The connection erros are handelt through the [TasksetOptionsBloc]
///
/// * see also
///    [TasksetOptionsBloc]
///    [TasksetOptionsEvent]
///    [TasksetOptionsState]
///
/// Author: L.Kammerer
/// latest Changes: 15.07.2021
class OptionTaskScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OptionTaskScreennState();
  }
}

///OptionTaskScreennState provides the state for the [OptionTaskScreen]
class OptionTaskScreennState extends State<OptionTaskScreen> {
  //[_formKey] should be used to identify every Form in this Screen
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //temporary url to prevent losing the url on error states
  String urlInitValue;

  @override
  void initState() {
    super.initState();
  }

  ///override build methode [StatelessWidget]
  ///
  ///{@param} [BuildContext] as context
  ///
  ///{@return} [Widget] decided by the incoming state of the [TasksetOptionsBloc]
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      //avoid overflow because of the keyboard
      resizeToAvoidBottomInset: false,
      appBar: _bar(screenSize.width / 5),
      body: BlocListener(
        bloc: BlocProvider.of<TasksetOptionsBloc>(context),
        listener: (context, state) {
          ///url insert successfull the [urlInitValue] set to null
          ///old [SnackBar] disappears
          if (state is TasksetOptionsPushSuccess) {
            urlInitValue = null;
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(_saveSuccess());
          }

          ///url insert failed an error message pops up
          ///old [SnackBar] disappears
          if (state is TasksetOptionsPushFailed) {
            urlInitValue = state.failedUrl;
            showDialog(
                context: context,
                builder: (_) => _insertErrorPopUp(state.error));
          }

          ///url delete succeeded
          ///old [SnackBar] disappears
          if (state is TasksetOptionsDeleteSuccess) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(_deleteSuccess());
          }

          ///tapping on an url shows an pop up with details about the url
          if (state is TasksetOptionsUrlSelected) {
            showDialog(context: context, builder: (_) => _urlPopUp(state.url));
          }
        },
        child: BlocBuilder<TasksetOptionsBloc, TasksetOptionsState>(
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
            if (state is TasksetOptionsWaiting) {
              return Center(child: CircularProgressIndicator());
            }
            context.read<TasksetOptionsBloc>().add(TasksetOptionsReload());
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  ///(private)
  ///is used to input an url
  ///
  ///{@important} the input should be saved in local
  ///variable to avoid lost on state changes. The url that is used for the https request
  ///is stored in [TasksetOptionsBloc]. The onChanged is used to send the
  ///[TextFormField] value through [TasksetOptionsBloc] via [TasksetOptionsChangeURL]
  ///
  ///{@params}
  ///[BuildContext] context
  ///initialValue of [TextFormField] as [String] initValue
  ///
  ///{@return} [Form] with [TextFormField] to provide input with validation
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
                  .read<TasksetOptionsBloc>()
                  .add(TasksetOptionsChangeURL(value))
            },
            validator: (value) => InputValidation.inputURLValidation(value),
            onFieldSubmitted: (value) => {
              if (_formKey.currentState.validate())
                context.read<TasksetOptionsBloc>().add(TasksetOptionsPush())
            },
          ),
        ],
      ),
    );
  }

  ///(private)
  ///is used to show all [TaskUrl] stored in the Database
  ///
  ///[ListView] for all [TaskUrl] stored in the Database.
  ///If an Urls is longer than 30 symbols the first 7 symbols are cut
  ///and every after the 32 symbol is cut of and the url ends with '...'
  ///Also behind the [TaskUrl] an delete button is available
  ///
  ///{@params}
  ///all [TaskUrl] as [List]<[TaskUrl]> urls
  ///
  ///{@return} [ListView] with urls
  Widget _tasksetUrlList(List<TaskUrl> urls) {
    return ListView.builder(
      ///blocking the scroll function for this list
      ///because it should be wrapt in another [ListView]
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: urls.length,
      itemBuilder: (context, index) {
        return Row(
          children: [
            //show details of the url onPressed
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
                    .read<TasksetOptionsBloc>()
                    .add(TasksetOptionsSelectUrl(urls[index]));
              },
            ),
            Spacer(),
            //button to delete the url in the Database
            IconButton(
              icon: Icon(
                Icons.delete_forever_rounded,
                color: LamaColors.redAccent,
                size: 25,
              ),
              onPressed: () {
                context
                    .read<TasksetOptionsBloc>()
                    .add(TasksetOptionsDelete(urls[index]));
              },
            )
          ],
        );
      },
    );
  }

  ///(private)
  ///is used to show all urls which are deleted in the time
  ///this screen is used
  ///
  ///If an Urls is longer than 30 symbols the first 7 symbols are cut
  ///and every after the 32 symbol is cut of and the url ends with '...'
  ///Also behind the url an ReAdd button to insert the url in the Database again
  ///
  ///{@params}
  ///all urls as [List]<[TaskUrl]> urls
  ///
  ///{@return} [ListView] with urls
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
            //button to insert the url in the Database again
            IconButton(
              icon: Icon(
                Icons.replay_rounded,
                color: LamaColors.bluePrimary,
                size: 25,
              ),
              onPressed: () {
                context
                    .read<TasksetOptionsBloc>()
                    .add(TasksetOptionsReAddUrl(urls[index]));
              },
            )
          ],
        );
      },
    );
  }

  ///(private)
  ///provides [AlertDialog] to show details about an specific url
  ///
  ///{@param} url as String
  Widget _urlPopUp(String url) {
    return AlertDialog(
      title: Text(
        'Taskset URL',
        style: LamaTextTheme.getStyle(
          color: LamaColors.black,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Text(
          url,
          style: LamaTextTheme.getStyle(
            color: LamaColors.black,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            monospace: true,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      actions: [
        TextButton(
          child: Text('Schließen'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  ///(private)
  ///provides [SnackBar] with [_snackbar] to show an successfull delet of an url
  ///into the Database
  Widget _deleteSuccess() {
    return _snackbar(Icons.delete_forever_rounded, 'URL erfolgreich gelöscht!',
        LamaColors.redAccent);
  }

  ///(private)
  ///provides [SnackBar] with [_snackbar] to show an successfull insert of an url
  ///into the Database
  Widget _saveSuccess() {
    return _snackbar(
        Icons.check_rounded, 'Änderung erfogreich!', LamaColors.greenPrimary);
  }

  ///(private)
  ///provides [AlertDialog] to show error message
  ///
  ///{@param} error message as String
  Widget _insertErrorPopUp(String error) {
    return AlertDialog(
      title: Text(
        'Fehler beim laden der Aufgaben',
        style: LamaTextTheme.getStyle(
          color: LamaColors.black,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Text(
          error,
          style: LamaTextTheme.getStyle(
            color: LamaColors.black,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            monospace: true,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      actions: [
        TextButton(
          child: Text('Schließen'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  ///(private)
  ///is used for headlines
  ///
  ///{@param} headline as [String] headline
  ///
  ///{@return} [Align] with [Text]
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

  ///(private)
  ///provides default design for an [SnackBar] on this screen
  ///
  ///{@params}
  ///[SnackBar] [Icon] as IconData icon
  ///[SnackBar] [Text] as String msg
  ///[SnackBar] backgroundColor as Color color
  Widget _snackbar(IconData icon, String msg, Color color) {
    return SnackBar(
      duration: Duration(seconds: 2, milliseconds: 50),
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

  ///(private)
  ///porvides [AppBar] with default design for Screens used by the Admin
  ///
  ///{@params}
  ///[AppBar] size as double size
  ///
  ///{@return} [AppBar] with generel AdminMenu specific design
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
