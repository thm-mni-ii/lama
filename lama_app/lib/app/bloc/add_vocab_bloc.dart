import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/event/add_vocab_events.dart';
import 'package:lama_app/app/state/add_vocab_state.dart';

class AddVocabBloc extends Bloc<AddVocabEvent, AddVocabState> {
  AddVocabBloc({AddVocabState? initialState}) : super(LoadingAddVocabState()) {
    on<AddVocabCamEvent>((event, emit) async {
      emit(LoadingAddVocabState());

      await Future.delayed(Duration(milliseconds: 200));
      emit(LoadedAddVocabState());
    });
    on<EditableEvent>((event, emit) async {
      emit(EditableState());
    });
    on<ReorderEvent>((event, emit) async {
      emit(ReorderState());
    });
  }
}
