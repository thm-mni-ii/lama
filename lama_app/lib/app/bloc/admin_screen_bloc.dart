import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/event/admin_screen_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/app/state/admin_state.dart';
import 'package:lama_app/db/database_provider.dart';

class AdminScreenBloc extends Bloc<AdminScreenEvent, AdminState> {
  UserRepository userRepo;
  AdminScreenBloc({AdminState initialState, this.userRepo})
      : super(initialState);

  @override
  Stream<AdminState> mapEventToState(AdminScreenEvent event) async* {
    if (event is LoadAllUsers) yield await _loadUsers();
  }

  Future<Loaded> _loadUsers() async {
    List<User> userList = await DatabaseProvider.db.getUser();
    return Loaded(userList);
  }
}
