import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lama_app/app/bloc/user_login_bloc.dart';
import 'package:lama_app/app/event/user_login_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/state/user_login_state.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
import 'package:lama_app/util/input_validation.dart';

class UserLoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserLoginScreenState();
  }
}

<<<<<<< HEAD
class UserSelectionState extends State<UserLoginScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
=======
class UserLoginScreenState extends State<UserLoginScreen> {
  var _formKey = GlobalKey<FormState>();
>>>>>>> Add UserSelectionScreen and redirect to it
  @override
  void initState() {
    super.initState();
    context.read<UserLoginBloc>().add(UserLoginPullUser());
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _bar(screenSize.width / 5),
      body: BlocBuilder<UserLoginBloc, UserLoginState>(
        builder: (context, state) {
          if (state is UserLoginPulled) {
            return _input(
                context, null, state.user, screenSize.width, _formKey);
          }
          if (state is UserLoginFailed) {
            return _input(
                context, state.error, state.user, screenSize.width, _formKey);
          }
          if (state is UserLoginSuccessful) {
            return Container(
              alignment: Alignment(0, 0),
              child: Icon(
                Icons.check,
                color: LamaColors.greenAccent,
                size: 100,
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

Widget _input(BuildContext context, String error, User user, double size,
    GlobalKey<FormState> key) {
  String _nameDisplay = user.isAdmin ? user.name + ' (Admin)' : user.name;
  return Form(
    key: key,
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 30, bottom: 30),
          child: Column(
            children: [
              CircleAvatar(
                child: SvgPicture.asset(
                  'assets/images/svg/avatars/${user.avatar}.svg',
                  semanticsLabel: 'LAMA',
                ),
                radius: 35,
                backgroundColor: LamaColors.mainPink,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                _nameDisplay,
                style: LamaTextTheme.getStyle(
                  fontSize: 22,
                  color: LamaColors.black,
                  monospace: true,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 20, left: 20, bottom: 30),
          child: TextFormField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: 'Passwort',
              errorText: error,
            ),
            validator: (value) => InputValidation.isEmpty(value)
                ? 'Eingabe darf nicht leer sein!'
                : null,
            onChanged: (value) =>
                context.read<UserLoginBloc>().add(UserLoginChangePass(value)),
            obscureText: true,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                if (key.currentState.validate())
                  context.read<UserLoginBloc>().add(UserLogin(user, context));
              },
              child: Row(
                children: [
                  Icon(Icons.check_rounded),
                  SizedBox(width: 10),
                  Text('Einloggen'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(250, 50),
                primary: LamaColors.greenPrimary,
                shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(0)),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            ElevatedButton(
              onPressed: () {
                context.read<UserLoginBloc>().add(UserLoginAbort(context));
              },
              child: Icon(Icons.close_rounded),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(50, 50),
                primary: LamaColors.redAccent,
                shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(0)),
              ),
            ),
          ],
        )
      ],
    ),
  );
}

Widget _bar(double size) {
  return AppBar(
    title: Text('Anmeldung', style: LamaTextTheme.getStyle(fontSize: 18)),
    toolbarHeight: size,
    backgroundColor: LamaColors.mainPink,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(30),
      ),
    ),
  );
}
