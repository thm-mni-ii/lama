import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_admin_bloc.dart';
import 'package:lama_app/app/event/create_admin_event.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
import 'package:lama_app/util/input_validation.dart';

class CreateAdminScreen extends StatefulWidget {
  @override
  _CreateAdminScreenState createState() => _CreateAdminScreenState();
}

class _CreateAdminScreenState extends State<CreateAdminScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _secondPass;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
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
                  onChanged: (value) => _secondPass = value,
                  obscureText: true,
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Passwort wiederholen'),
                  validator: (String value) {
                    return InputValidation.inputPasswortValidation(value,
                        secondPass: _secondPass);
                  },
                  onChanged: (value) => context
                      .read<CreateAdminBloc>()
                      .add(CreateAdminChangePassword(value)),
                  obscureText: true,
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
