import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/util/pair.dart';

class VocableTestTaskBloc
    extends Bloc<VocableTestTaskEvent, VocableTestTaskState> {
  List<Pair<String, String>> wordPairs;

  VocableTestTaskBloc() : super(VocableTestTaskState());

  @override
  Stream<VocableTestTaskState> mapEventToState(VocableTestTaskEvent event) {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }
}

class VocableTestTaskEvent {}

class AnswerPairEvent extends VocableTestTaskEvent {}

class VocableTestTaskState {}
