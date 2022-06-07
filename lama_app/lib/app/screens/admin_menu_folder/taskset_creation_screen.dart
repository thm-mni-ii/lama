import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
import 'package:lama_app/util/input_validation.dart';
import 'package:lama_app/app/bloc/taskset_options_bloc.dart';
import 'package:lama_app/app/event/taskset_options_event.dart';
import 'package:lama_app/app/model/taskUrl_model.dart';

import '../../bloc/user_selection_bloc.dart';
import '../user_selection_screen.dart';


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
class TasksetCreationScreen extends StatefulWidget {
  final BoxConstraints constraints;

  const TasksetCreationScreen({Key key, this.constraints}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return TasksetCreationScreenState(constraints);
  }
}

///OptionTaskScreennState provides the state for the [OptionTaskScreen]
class TasksetCreationScreenState extends State<TasksetCreationScreen> {
  //[_formKey] should be used to identify every Form in this Screen
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //temporary url to prevent losing the url on error states
  String urlInitValue;
  final BoxConstraints constraints;

  TasksetCreationScreenState(this.constraints);

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
    var klassenStufe = [
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
    ];

    var facher = [
      "Mathe",
      "Deutsch",
      "Englisch",
      "Sachkunde"
    ];
    Size screenSize = MediaQuery.of(context).size;
    var _currentSelectedValue;
    var _currentSelectedValue2;
    return Scaffold(
      appBar: _bar(screenSize.width / 5, 'Tasksets erstellen', LamaColors.bluePrimary),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            // create space between each childs
            child: Stack(
              children: [
                 Column(
                    children: [

                      Container(
                      alignment: Alignment.centerLeft,
                      child: Text.rich(
                        TextSpan(
                            text: 'Tasksetname',
                            style: TextStyle(
                              fontSize: 16,
                            )),
                        ),
                      ),
                 Divider(),

                      Container(
                      margin: EdgeInsets.only(top: 15),
                      alignment: Alignment.centerLeft,
                      child: Text.rich(
                        TextSpan(
                            text: 'Kurzbeschreibung',
                            style: TextStyle(
                              fontSize: 16,
                            )),
                      ),
                 ),
                 Divider(),

                      Container(
                        margin: EdgeInsets.only(top: 45),
                        alignment: Alignment.centerLeft,
                        child: Text.rich(
                        TextSpan(
                            text: 'Klassenstufe',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      ),

                      Container(
                        child: InputDecorator(
                          decoration: InputDecoration(
                            errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                            hintText: 'Klassenstufe auswählen',
                            ), 
                          isEmpty: _currentSelectedValue == '',
                          child: DropdownButtonHideUnderline(  
                            child: 
                              DropdownButton<String>(
                                value: _currentSelectedValue,
                                isDense: true,
                                onChanged: (String newValue){
                                  setState(() {
                                    _currentSelectedValue = newValue;
                                  });
                                },
                                items: klassenStufe.map((String value){
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value)
                              );
                              }).toList(),
                        ),)
                          ),
                        ),

                        Container(
                        margin: EdgeInsets.only(top: 15),
                        alignment: Alignment.centerLeft,
                        child: Text.rich(
                        TextSpan(
                            text: 'Fach',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      ),

                        Container(
                        child: InputDecorator(
                          decoration: InputDecoration(
                            errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                            hintText: 'Fach auswählen',
                            ), 
                          isEmpty: _currentSelectedValue2 == '',
                          child: DropdownButtonHideUnderline(  
                            child: 
                              DropdownButton<String>(
                                value: _currentSelectedValue2,
                                isDense: true,
                                onChanged: (String newValue){
                                  setState(() {
                                    _currentSelectedValue2 = newValue;
                                  });
                                },
                                items: facher.map((String value){
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value)
                              );
                              }).toList(),
                        ),)
                          ),
                        ),

                        Container(
                        margin: EdgeInsets.only(top: 50),
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: null,
                          child: Text.rich(
                                TextSpan(
                                  text: 'Weiter',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                            )),
                      ),
                        )
                        
                      ),
                 ],
                )
              ],
            ),
          ),
          //Items
        ],
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
  Widget _bar(double size, String titel, Color colors) {
    return AppBar(
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (BuildContext context) => UserSelectionBloc(),
                    child: UserSelectionScreen(),
                  ),
                ),
              );
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ),
      title: Text(
        titel,
        style: LamaTextTheme.getStyle(fontSize: 18),
      ),
      toolbarHeight: size,
      backgroundColor: colors,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
    );
  }
}
