import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/event/add_vocab_events.dart';
import 'package:lama_app/app/event/choose_taskset_events.dart';
import 'package:lama_app/app/repository/taskset_repository.dart';
import 'package:lama_app/app/state/add_vocab_state.dart';
import 'package:lama_app/app/state/choose_taskset_state.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';

class AddVocabBloc extends Bloc<AddVocabCamEvent, AddVocabState> {

  AddVocabBloc() : super(LoadingAddVocabState()) {
    on<AddVocabCamEvent>((event, emit) async {
      emit(LoadingAddVocabState());

      await Future.delayed(Duration(milliseconds: 200));
      emit(LoadedAddVocabState());
    });
  }
}
