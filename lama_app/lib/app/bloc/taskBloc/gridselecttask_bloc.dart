import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/util/pair.dart';

///[Bloc] for the [GridSelectTaskScreen]
///
/// * see also
///     [GridSelectTaskScreen]
///     [SelectGridLetterEvent]
///     [GridSelectTaskState]
///
/// Author: K.Binder
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

/// Event for the [GridSelectTaskBloc]
///
/// Author: K.Binder
class SelectGridLetterEvent {
  Pair position;
  SelectGridLetterEvent(this.position);
}

/// State for the [GridSelectTaskBloc]
///
/// Author: K.Binder
class GridSelectTaskState {
  List<Pair> selectedWords;
  GridSelectTaskState(this.selectedWords);
}
