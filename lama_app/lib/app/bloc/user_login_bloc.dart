import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/event/user_login_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/state/user_login_state.dart';
import 'package:lama_app/db/database_provider.dart';

class UserLoginBloc extends Bloc<UserLoginEvent, UserLoginState> {
  String _pass;
  User user;
  UserLoginBloc({UserLoginState initialState, this.user}) : super(initialState);

  @override
  Stream<UserLoginState> mapEventToState(UserLoginEvent event) async* {
    if (event is UserLoginPullUser) yield UserLoginPulled(user);
    if (event is UserLogin) yield await validateUserLogin(event);
    if (event is UserLoginAbort) _abortLogin(event.context);
    if (event is UserLoginChangePass) _pass = event.pass;
  }

  Future<UserLoginState> validateUserLogin(UserLogin event) async {
    if ((_pass != null && event.user != null) &&
        await DatabaseProvider.db.checkPassword(_pass, event.user) == 1) {
      Navigator.pop(event.context, user);
      return UserLoginSuccessful();
    }
    return UserLoginFailed(event.user,
        error: 'Das Passwort passt nicht zu diesem Nutzer!');
  }

  void _abortLogin(BuildContext context) {
    Navigator.pop(context, null);
  }
}
