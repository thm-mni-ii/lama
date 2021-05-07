import 'package:flutter/material.dart';

class CreateAdmin extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administrator erstellen'),
      ),
      body: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(hintText: 'Nutzername'),
            validator: (String value) {
              return validatiorInput(value);
            },
          ),
          TextFormField(
            decoration: InputDecoration(hintText: 'Passwort'),
            validator: (String value) {
              return validatiorInput(value);
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    //TODO Daten an Datenbank senden
                  }
                },
                child: Text('Speichern')),
          )
        ],
      ),
      backgroundColor: Color(0xFFFFFF),
    );
  }

  String validatiorInput(String input) {
    if (input == null || input.isEmpty) {
      return 'Das Feld darf nicht leer sein!';
    }
    return null;
  }
}
