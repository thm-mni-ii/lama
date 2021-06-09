import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/user_management_bloc.dart';
import 'package:lama_app/app/event/user_login_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/repository/lamafacts_repository.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/app/screens/admin_menu_screen.dart';
import 'package:lama_app/app/screens/user_management_screen.dart';
import 'package:lama_app/app/screens/home_screen.dart';
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
      UserRepository repository = UserRepository(event.user);
      if (event.user.isAdmin) {
        Navigator.pushReplacement(
            event.context,
            /*MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (BuildContext context) => UserManagementBloc(),
              child: UserManagementScreen(),
            ),*/
            MaterialPageRoute(builder: (context) => AdminMenuScreen()));
      } else {
        LamaFactsRepository lamaFactsRepository = LamaFactsRepository();
        await lamaFactsRepository.loadFacts();
        Navigator.pushReplacement(
            event.context,
            MaterialPageRoute(
                builder: (context) => MultiRepositoryProvider(providers: [
                      RepositoryProvider<UserRepository>(
                          create: (context) => repository),
                      RepositoryProvider<LamaFactsRepository>(
                          create: (context) => lamaFactsRepository)
                    ], child: HomeScreen())));
      }
      _pass = null;
      return UserLoginSuccessful();
    } else {
      return UserLoginFailed(event.user,
          error: 'Das Passwort passt nicht zu diesem Nutzer!');
    }
  }

  void _abortLogin(BuildContext context) {
    Navigator.pop(context);
  }
}
