import 'package:flame/components/timer_component.dart';
import 'package:flame/time.dart';

class MonkeyTimer extends TimerComponent {
  final name = "MonkeyTimer";
  static const _seconds = 360.0;

  MonkeyTimer() : super(Timer(_seconds));
}