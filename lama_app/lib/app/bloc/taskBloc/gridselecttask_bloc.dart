import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/util/pair.dart';

class GridSelectTaskBloc
    extends Bloc<SelectGridLetterEvent, GridSelectTaskState> {
  List<Pair> selectedTableItems = [];

  GridSelectTaskBloc() : super(GridSelectTaskState([]));

  @override
  Stream<GridSelectTaskState> mapEventToState(
      SelectGridLetterEvent event) async* {
    if (!selectedTableItems.contains(event.position))
      selectedTableItems.add(event.position);
    else
      selectedTableItems.remove(event.position);
    yield GridSelectTaskState(selectedTableItems);
  }
}

class SelectGridLetterEvent {
  Pair position;
  SelectGridLetterEvent(this.position);
}

class GridSelectTaskState {
  List<Pair> selectedWords;
  GridSelectTaskState(this.selectedWords);
}
