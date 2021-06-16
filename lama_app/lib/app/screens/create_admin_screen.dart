import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/user_selection_bloc.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/screens/user_selection_screen.dart';
import 'package:lama_app/db/database_provider.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
import 'package:lama_app/util/input_validation.dart';

class CreateAdminScreen extends StatelessWidget {
  final User _user = User(
    name: '',
    password: '',
    grade: 3,
    coins: 0,
    isAdmin: true,
    avatar: 'admin',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LamaColors.bluePrimary,
        title: Text(
          'Administrator erstellen',
          style: LamaTextTheme.getStyle(fontSize: 18),
        ),
      ),
      body: _form(context),
    );
  }

  Widget _form(BuildContext context) {
    var _formKey = GlobalKey<FormState>();
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.all(10.0),
              child: TextFormField(
                //inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]"))],
                decoration: InputDecoration(hintText: 'Nutzername'),
                validator: (String value) {
                  return InputValidation.inputUsernameValidation(value);
                },
                onChanged: (value) => _user.name = value,
              )),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              //inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]"))],
              decoration: InputDecoration(hintText: 'Passwort'),
              validator: (String value) {
                return InputValidation.inputPasswortValidation(value);
              },
              onChanged: (value) => _user.password = value,
              obscureText: true,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: Size(250, 45), primary: LamaColors.bluePrimary),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                await DatabaseProvider.db.insertUser(_user);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (BuildContext context) => UserSelectionBloc(),
                      child: UserSelectionScreen(),
                    ),
                  ),
                );
              }
            },
            child: Text(
              'Speichern',
              style: LamaTextTheme.getStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
