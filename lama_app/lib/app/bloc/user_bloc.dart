import 'package:bloc/bloc.dart';
import 'package:lama_app/app/event/database_event/add_entry.dart';
import 'package:lama_app/app/event/database_event/delete_entry.dart';
import 'package:lama_app/app/event/database_event/entry_event.dart';
import 'package:lama_app/app/event/database_event/set_entry.dart';
import 'package:lama_app/app/event/database_event/update_entry.dart';
import 'package:lama_app/app/model/user_model.dart';

class UserBloc extends Bloc<EntryEvent, List<User>> {
  UserBloc(List<User> initialState) : super(initialState);

  List<User> get intitialState => List<User>();

  @override
  Stream<List<User>> mapEventToState(EntryEvent event) async* {
    if (event is SetUser) {
      yield event.userList;
    } else if (event is AddUser) {
      List<User> newState = List.from(state);
      if (event.newUser != null) {
        newState.add(event.newUser);
      }
      yield newState;
    } else if (event is DeleteUser) {
      List<User> newState = List.from(state);
      newState.removeAt(event.userIndex);
      yield newState;
    } else if (event is UpdateUser) {
      List<User> newState = List.from(state);
      newState[event.userIndex] = event.newUser;
      yield newState;
    }
  }
}