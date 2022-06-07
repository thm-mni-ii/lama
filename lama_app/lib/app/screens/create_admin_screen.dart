import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//Lama default
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
import 'package:lama_app/util/input_validation.dart';
//Blocs
import 'package:lama_app/app/bloc/create_admin_bloc.dart';
//Events
import 'package:lama_app/app/event/create_admin_event.dart';

///This file creates the create admin screen
///the create admin screen provides the function to
///create an admin entering the name and an password
///
/// * see also
///    [CreateAdminBloc]
///    [CreateAdminEvent]
///    [CreateAdminState]
///
/// Author: L.Kammerer
/// latest Changes: 09.07.2021
class CreateAdminScreen extends StatefulWidget {
  @override
  _CreateAdminScreenState createState() => _CreateAdminScreenState();
}

///_CreateAdminScreenState provides the state for the [CreateAdminScreen]
class _CreateAdminScreenState extends State<CreateAdminScreen> {
  //[_formKey] should be used to identify every Form in this Screen
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //temporary password for double password validation
  String _secondPass;
  //temporary _saftyQuestion to avoid an empty safty answer if an safty question is used
  String _saftyQuestion;

  ///override build methode [StatelessWidget]
  ///
  ///{@param} [BuildContext] as context
  ///
  ///{@return} [Scaffold] with appBar [_bar] and body [_form]
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      //avoid overflow because of the keyboard
      resizeToAvoidBottomInset: false,
      appBar: _bar(
        screenSize.width / 5,
        'Administrator erstellen',
        LamaColors.bluePrimary,
      ),
      body: _form(context),
      floatingActionButton: _userOptionsButtons(context),
    );
  }

  ///(private)
  ///[Columne] with all inputs as [TextFormField] thats needed
  ///for creating an admin.
  ///
  ///All changes are made onChange through the [CreateAdminBloc] via [CreateAdminChange***]
  ///to validat the input the [InputValidation] is used.
  ///
  ///{@param} [BuildContext] as context
  ///
  ///{@return} [Widget] with every input as [TextFormField]
  Widget _form(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                    decoration: InputDecoration(hintText: 'Nutzername'),
                    validator: (String value) {
                      return InputValidation.inputUsernameValidation(value);
                    },
                    onChanged: (value) => context
                        .read<CreateAdminBloc>()
                        .add(CreateAdminChangeName(value))),
                SizedBox(height: 25),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Passwort'),
                  validator: (String value) {
                    return InputValidation.inputPasswortValidation(value);
                  },

                  ///this input value isn't used to change the value via [CreateAdminBloc]
                  ///it is used to validate the first password input with the second one
                  ///to provide this validation the value is temporary saved in [_secondPass]
                  onChanged: (value) => _secondPass = value,
                  obscureText: true,
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Passwort wiederholen'),
                  validator: (String value) {
                    ///this value and the [_secondPass] is used to validat the password input
                    ///in generell. If both values aren't equal an error message returns.
                    ///Else the validation returns with null.
                    return InputValidation.inputPasswortValidation(value,
                        secondPass: _secondPass);
                  },
                  onChanged: (value) => context
                      .read<CreateAdminBloc>()
                      .add(CreateAdminChangePassword(value)),
                  obscureText: true,
                ),
                SizedBox(height: 50),

                ///
                ///Safty question
                ///
                Text(
                  "Sicherheitsfrage (Optional)",
                  style: LamaTextTheme.getStyle(
                      fontSize: 18, color: LamaColors.black),
                ),
                Text(
                  "\n *Zur Wiederherstellung des Passworts, falls dieses verloren geht.",
                  style: LamaTextTheme.getStyle(
                      fontSize: 12, color: LamaColors.black),
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Frage'),
                  validator: (String value) {
                    return null;
                  },
                  onChanged: (value) {
                    _saftyQuestion = value;
                    context
                        .read<CreateAdminBloc>()
                        .add(CreateAdminChangeSaftyQuestion(value));
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Antwort'),
                  validator: (String value) {
                    if (InputValidation.isEmpty(value) &&
                        !InputValidation.isEmpty(_saftyQuestion))
                      return "Feld darf nicht leer sein, wenn eine Sicherheitsfrage genutzt wird.";
                    return null;
                  },
                  onChanged: (value) => context
                      .read<CreateAdminBloc>()
                      .add(CreateAdminChangeSaftyAnswer(value)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///(private)
  ///porvides [Row] with default designed abort and save [Ink] Button
  ///
  ///{@params} [BuildContext] context
  ///
  ///{@return} [Row] with two [Ink] Buttons
  Widget _userOptionsButtons(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: Ink(
            decoration: ShapeDecoration(
              color: LamaColors.greenPrimary,
              shape: CircleBorder(),
            ),
            padding: EdgeInsets.all(7.0),
            child: IconButton(
              icon: Icon(Icons.save, size: 28),
              color: Colors.white,
              tooltip: 'Speichern',
              onPressed: () {
                if (_formKey.currentState.validate())
                  context.read<CreateAdminBloc>().add(CreateAdminPush(context));
              },
            ),
          ),
        ),
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
              context.read<CreateAdminBloc>().add(CreateAdminAbort(context));
            },
          ),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.end,
    );
  }

  ///(private)
  ///porvides [AppBar] with default design for Screens used by the Admin
  ///
  ///{@params}
  ///[AppBar] size as double size
  ///[AppBar] titel as String title
  ///[AppBar] [Color] as colors
  ///
  ///{@return} [AppBar] with generel AdminMenu specific design
  Widget _bar(double size, String titel, Color colors) {
    return AppBar(
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
