import 'package:bloc/bloc.dart';
import 'package:lama_app/app/event/check_screen_event.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/state/check_screen_state.dart';
import 'package:lama_app/db/database_provider.dart';

class CheckScreenBloc extends Bloc<CheckScreenEvent, CheckScreenState> {
  CheckScreenBloc({CheckScreenState initialState}) : super(initialState);


  @override
  Stream<CheckScreenState> mapEventToState(CheckScreenEvent event) async* {
    if(event is CheckForAdmin) yield await _hasAdmin();
  }

  
  Future<CheckScreenState> _hasAdmin() async {
    List<User> userList = await DatabaseProvider.db.getUser();
    for (User user in userList) {
      if (user.isAdmin) return AdminExist();
    }
    return NoAdmin();
  }