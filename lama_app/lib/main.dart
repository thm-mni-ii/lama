import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/snake/snake_game.dart';

void main() async {
  runApp(
    BlocProvider(
        create: (context) => NavigationBloc(),
        child: LamaApp()
    ),
  );
}

class LamaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<NavigationBloc, NavigationState>(
          builder: (_, state) {
            if (state is NavigationHomeState) {
              return HomeScreen();
            }
            else if (state is NavigationTaskState) {
              return TaskScreen();
            }

            SnakeGame game = SnakeGame();
            return game.widget;
          }
      ),
    );
  }
}

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

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: OutlinedButton(
                child: Text('Aufgabe'),
                onPressed: () {
                  BlocProvider.of<NavigationBloc>(context).add(NavigationEvent.task);
                },
              )
          ),
          Center(
              child: OutlinedButton(
                child: Text('Snake'),
                onPressed: () {
                  BlocProvider.of<NavigationBloc>(context).add(NavigationEvent.snake);
                },
              )
          )],
      ),
    );
  }
}

class TaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: OutlinedButton(
          child: Text('Back!'),
          onPressed: () {
            BlocProvider.of<NavigationBloc>(context).add(NavigationEvent.home);
          },
        ),
      ),
    );
  }
}