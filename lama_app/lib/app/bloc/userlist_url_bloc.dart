import 'package:bloc/bloc.dart';
import 'package:lama_app/app/event/userlist_url_event.dart';
import 'package:lama_app/app/state/userlist_url_state.dart';

class UserlistUrlBloc extends Bloc<UserlistUrlEvent, UserlistUrlState> {
  UserlistUrlBloc({UserlistUrlState initialState}) : super(initialState);

  @override
  Stream<UserlistUrlState> mapEventToState(UserlistUrlEvent event) async* {}
}
