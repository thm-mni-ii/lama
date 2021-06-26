import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_user_bloc.dart';
import 'package:lama_app/app/event/create_user_event.dart';
import 'package:lama_app/app/state/create_user_state.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
import 'package:lama_app/util/input_validation.dart';

import 'admin_menu_screen.dart';

class UserlistUrlScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserlistUrlScreenState();
  }
}

class UserlistUrlScreenState extends State<UserlistUrlScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AdminUtils.appbar(
          screenSize, LamaColors.bluePrimary, 'Nutzerliste einfügen'),
      body: Container(
        child: Text('UserlistUrlScreen'),
      ),
    );
  }
}
