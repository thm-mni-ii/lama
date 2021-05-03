import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {}

enum NavigationEvent { home, task, snake }

@immutable
abstract class NavigationState {}

class NavigationHomeState extends NavigationState {}
class NavigationSnakeState extends NavigationState {}
class NavigationTaskState extends NavigationState {}


class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationHomeState());

  @override
  Stream<NavigationState> mapEventToState(NavigationEvent event) async* {
    switch (event) {
      case NavigationEvent.home : {
        yield NavigationHomeState();
        break;
      }
      case NavigationEvent.task : {
        yield NavigationTaskState();
        break;
      }
      case NavigationEvent.snake : {
        yield NavigationSnakeState();
        break;
      }
    }
  }
}