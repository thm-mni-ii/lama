import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/event/choose_taskset_events.dart';
import 'package:lama_app/app/state/choose_taskset_state.dart';

class ChooseTasksetBloc extends Bloc<ChooseTasksetEvent, ChooseTasksetState> {
  ChooseTasksetBloc() : super(LoadingAllTasksetsState());

  @override
  Stream<ChooseTasksetState> mapEventToState(ChooseTasksetEvent event) async* {
    if (event is LoadAllTasksetsEvent) yield LoadingAllTasksetsState();
    //TODO fetch all tasksets from repository
    //TODO return a state which contains all tasksets
  }
}
