import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/check_screen_bloc.dart';
import 'package:lama_app/app/screens/check_Screen.dart';

class LamaApp extends MaterialApp {
  LamaApp()
      : super(
          debugShowCheckedModeBanner: false,
          title: "LAMA",
          builder: (context, child) {
            return ScrollConfiguration(
              behavior: LamaScrollBehaivour(),
              child: child,
            );
          },
          home: BlocProvider(
            create: (BuildContext context) => CheckScreenBloc(),
            child: CheckScreen(),
          ),
        );
}

class LamaScrollBehaivour extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
