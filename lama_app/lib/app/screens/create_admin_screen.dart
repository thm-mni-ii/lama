import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/user_login_bloc.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/screens/user_login_screen.dart';
import 'package:lama_app/db/database_provider.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

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
                decoration: InputDecoration(hintText: 'Nutzername'),
                validator: (String value) {
                  return validatiorInputName();
                },
                onChanged: (value) => _user.name = value,
              )),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              decoration: InputDecoration(hintText: 'Passwort'),
              validator: (String value) {
                return validatiorInputPassword();
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
                      create: (BuildContext context) => UserLoginBloc(),
                      child: UserLoginScreen(),
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

  String validatiorInputName() {
    if (_user.name == '' || _user.name.isEmpty || _user.name == null) {
      return 'Der Nutzername darf nicht leer sein!';
    }
    return null;
  }

  String validatiorInputPassword() {
    if (_user.password == '' ||
        _user.password.isEmpty ||
        _user.password == null) {
      return 'Das Password darf nicht leer sein!';
    }
    return null;
  }
}
