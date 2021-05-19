import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/event/admin_screen_event.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/app/state/admin_state.dart';

class AdminScreenBloc extends Bloc<AdminScreenEvent, AdminState> {
  AdminScreenBloc({AdminState initialState}) : super(initialState);
  RepositoryProvider<UserRepository> userRepo;

  @override
  Stream<AdminState> mapEventToState(AdminScreenEvent event) {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }
}
