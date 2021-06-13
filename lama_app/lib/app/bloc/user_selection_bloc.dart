import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
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

  Future<UsersLoaded> loadUsers() async {
    List<User> userList = await DatabaseProvider.db.getUser();
    return UsersLoaded(userList);
  }

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
          context, MaterialPageRoute(builder: (context) => AdminMenuScreen()));
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
