import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/safty_question_bloc.dart';
import 'package:lama_app/app/event/user_login_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/screens/safty_quastion_screen.dart';
import 'package:lama_app/app/state/user_login_state.dart';
import 'package:lama_app/db/database_provider.dart';

///[Bloc] for the [UserLoginScreen]
///
/// * see also
///    [UserLoginScreen]
///    [UserLoginEvent]
///    [UserLoginState]
///    [Bloc]
///
/// Author: L.Kammerer
/// latest Changes: 26.06.2021
class UserLoginBloc extends Bloc<UserLoginEvent, UserLoginState?> {
  ///typed password
  ///incoming events are used to change the value
  String? _pass;
  //user that wants to try the login
  User? user;
  UserLoginBloc({UserLoginState? initialState, this.user})
      : super(initialState) {
    on<UserLoginPullUser>((event, emit) async => emit(UserLoginPulled(user)));
    on<UserLogin>((event, emit) async => emit(await validateUserLogin(event)));
    on<UserLoginAbort>((event, emit) async => _abortLogin(event.context));
    on<UserLoginChangePass>((event, emit) async => _pass = event.pass);
    on<UserLoginForgotPassword>((event, emit) async {
      emit(await validateSaftyQuestion(event));
    });
  }

  ///validating the user login using [DatabaseProvider.db.checkPassword]
  ///if the login is successfull the screen is poped with
  ///the [user] that tryed to login
  ///on fail an [UserLoginFailed] with an error message is returned
  ///
  ///{@param}[UserLogin] as event
  Future<UserLoginState> validateUserLogin(UserLogin event) async {
    if ((_pass != null && event.user != null) &&
        await DatabaseProvider.db.checkPassword(_pass!, event.user) == 1) {
      Navigator.pop(event.context, user);
      return UserLoginSuccessful();
    }
    return UserLoginFailed(
      event.user,
      error: 'Das Passwort passt nicht zu diesem Nutzer!',
    );
  }

  Future<UserLoginState> validateSaftyQuestion(
      UserLoginForgotPassword event) async {
    bool? saftyQuestionBool = await Navigator.push(
      event.context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (BuildContext context) => SaftyQuestionBloc(user: user),
          child: SaftyQuestionScreen(user),
        ),
      ),
    );
    if (saftyQuestionBool == true) {
      Navigator.pop(event.context, user);
      return UserLoginSuccessful();
    }
    return UserLoginPulled(user);
  }

  ///(private)
  ///pops the Screen with null return
  ///
  ///{@param}[BuildContext] as context
  void _abortLogin(BuildContext context) => Navigator.pop(context, null);
}
