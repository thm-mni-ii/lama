import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/check_screen_bloc.dart';
import 'package:lama_app/app/screens/check_Screen.dart';

class LamaApp extends MaterialApp {
  LamaApp()
      : super(
          home: BlocProvider(
            create: (BuildContext context) => CheckScreenBloc(),
            child: CheckScreen(),
          ),
          /*BlocProvider(
            create: (BuildContext context) => UserLoginBloc(),
            child: UserLoginScreen(),
          ),*/
        );
}
