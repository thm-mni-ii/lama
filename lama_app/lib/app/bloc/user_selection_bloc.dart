import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/app/bloc/admin_menu_bloc.dart';
import 'package:lama_app/app/bloc/user_login_bloc.dart';
import 'package:lama_app/app/event/user_selection_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/repository/lamafacts_repository.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/app/screens/admin_menu_screen.dart';
import 'package:lama_app/app/screens/home_screen.dart';
import 'package:lama_app/app/screens/user_login_screen.dart';
import 'package:lama_app/app/state/user_selection_state.dart';
import 'package:lama_app/db/database_provider.dart';

///[Bloc] for the [UserSelectionScreen]
///
/// * see also
///    [UserSelectionScreen]
///    [UserSelectionEvent]
///    [UserSelectionState]
///    [Bloc]
///
/// Author: L.Kammerer
/// latest Changes: 15.06.2021
class UserSelectionBloc extends Bloc<UserSelectionEvent, UserSelectionState> {
  UserSelectionBloc({UserSelectionState initialState}) : super(initialState);

  @override
  Stream<UserSelectionState> mapEventToState(UserSelectionEvent event) async* {
    if (event is LoadUsers) yield await loadUsers();
    if (event is SelectUser) {
      await _userSelected(event.user, event.context);
      yield UserSelected(event.user);
    }
  }

  ///load all stored [User] from the database and
  ///pack them in [UsersLoaded] state
  ///
  ///{@return}[UsersLoaded] with all loaded [User]
  Future<UsersLoaded> loadUsers() async {
    List<User> userList = await DatabaseProvider.db.getUser();
    return UsersLoaded(userList);
  }

  ///(private)
  ///used to try an login for an specific [User]
  ///
  ///using navigation to the [UserLoginScreen] and awaits an
  ///successfull login.
  ///If the [UserLoginScreen] pops with [User] an navigation
  ///via [Navigator.pushReplacement] will be done. If the [User] is an admin
  ///the navigation leads to [AdminMenuScreen] else to the [HomeScreen]
  ///If the [UserLoginScreen] pops with null no action is done.
  ///
  ///{@params}
  ///[User] as user which try to login
  ///[BuildContext] as context
  Future<void> _userSelected(User user, BuildContext context) async {
    User selectedUser = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (BuildContext context) => UserLoginBloc(user: user),
          child: UserLoginScreen(),
        ),
      ),
    );
    if (selectedUser == null) return;
    UserRepository repository = UserRepository(selectedUser);
    if (selectedUser.isAdmin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (BuildContext context) => AdminMenuBloc(),
            child: AdminMenuScreen(),
          ),
        ),
      );
    } else {
      LamaFactsRepository lamaFactsRepository = LamaFactsRepository();
      await lamaFactsRepository.loadFacts();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MultiRepositoryProvider(providers: [
                    RepositoryProvider<UserRepository>(
                        create: (context) => repository),
                    RepositoryProvider<LamaFactsRepository>(
                        create: (context) => lamaFactsRepository)
                  ], child: HomeScreen())));
    }
  }
}
