import 'package:bloc/bloc.dart';
import 'package:lama_app/app/event/edit_user_event.dart';
import 'package:lama_app/app/state/edit_user_state.dart';

class EditUserBloc extends Bloc<EditUserEvent, EditUserState> {
  EditUserBloc(EditUserState initialState) : super(initialState);

  @override
  Stream<EditUserState> mapEventToState(event) async* {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }
}
