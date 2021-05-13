import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/screens/home_screen.dart';
import 'package:lama_app/app/screens/user_login_screen.dart';

import 'bloc/user_login_bloc.dart';

class LamaApp extends MaterialApp {
  LamaApp()
      : super(
          home: BlocProvider(
            create: (BuildContext context) => UserLoginBloc(),
            child: UserLoginScreen(),
          ),
        );
}
