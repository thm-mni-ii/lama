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
          ElevatedButton(
            child: Row(
              children: [
                Icon(Icons.save_sharp),
                SizedBox(width: 10),
                Text('Speichern'),
              ],
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(50, 50),
              primary: LamaColors.greenPrimary,
              shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
            ),
            onPressed: () {
              if (_formKey.currentState.validate())
                context.read<CreateAdminBloc>().add(CreateAdminPush(context));
            },
          ),
        ],
      ),
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
