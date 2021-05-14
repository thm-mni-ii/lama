import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/user_login_bloc.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/screens/user_login_screen.dart';
import 'package:lama_app/db/database_provider.dart';

class CreateAdminScreen extends StatelessWidget {
  final User _user = User(
    name: '',
    password: '',
    grade: 0,
    coins: 0,
    isAdmin: true,
    avatar: 'admin',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administrator erstellen'),
      ),
      body: Column(
        children: [
          SizedBox(height: 50),
          Padding(
              padding: EdgeInsets.all(20.0),
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: 'Nutzername', errorText: validatiorInputName()),
                validator: (String value) {
                  return validatiorInputPassword();
                },
                onChanged: (value) {
                  _user.name = value;
                  validatiorInputName();
                },
              )),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: 'Passwort', errorText: validatiorInputPassword()),
              validator: (String value) {
                return validatiorInputPassword();
              },
              onChanged: (value) => _user.password = value,
            ),
          ),
          SizedBox(height: 60),
          ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: Size(250, 45)),
              onPressed: () async {
                if (validatiorInputName() == null &&
                    validatiorInputPassword() == null) {
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
              child: Text('Speichern')),
        ],
      ),
      backgroundColor: Color(0xFFFFFFFF),
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
