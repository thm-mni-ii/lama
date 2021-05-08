import 'package:flutter/material.dart';
import 'package:lama_app/app/user_selection.dart';

class UserLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nutzerauswahl'),
      ),
      body: UserSelection(),
      backgroundColor: Color(0xFFFFFFFF),
    );
  }
}
