import 'package:flame/components.dart';

import 'package:lama_app/apeClimber/widgets/monkeyTimerWidget.dart';

import '../../apeClimberUpdate/climberGame2.dart';

/// This class is [TimerComponent] to display and handle the game timer.
class MonkeyTimer extends TimerComponent with HasGameRef<ApeClimberGame> {
  // SETTINGS
  // --------
  /// string which gets displayed of the widget when timer finished.
  static const _endString = "Ende";

  /// string which gets displayed of the widget when timer paused.
  static const _pauseString = "Pause";

  /// string which gets displayed of the widget when timer stopped.
  static const _stopString = "Stop";

  /// seconds the timer will run
  static const _seconds = 120.0;
  // --------
  // SETTINGS

  bool _started = false;

  /// This function gets called when the widget of the timer was updated
  late Function(MonkeyTimerWidget) onWidgetUpdated;

  /// This function gets called when the timer finished.
  late Function(MonkeyTimerWidget) onFinished;
  bool repeat = true;

  MonkeyTimer({required super.period}) {
    timer.repeat = true;
  }

/*   MonkeyTimer(this.onFinished) : super(Timer(_seconds,
      callback: () {
        onFinished.call(MonkeyTimerWidget(
          text: _endString,
          percent: 1,
        ));
      })); */

  void onTick() {
    this.game.decreaseTime();
    return;
  }

  void reset() {
    timer = Timer(_seconds);
    _started = false;
  }

  void start() {
    _started = true;
    timer.start();
  }

  void pause() {
    timer.pause();
  }

  void stop() {
    timer.stop();
  }

  void isFinished() {}

  @override
  void update(double dt) {
/*     if (timer.isRunning()) {
      var secondsLeft = (_seconds - timer.current).ceil();
      // calculate the minutes left
      var minLeft = ((secondsLeft) ~/ 60).toInt();
      // calculate the seconds left
      var secLeft = (secondsLeft - (minLeft * 60)).ceil();
      // calls the onWidgetUpdated function
      onWidgetUpdated.call(MonkeyTimerWidget(
        text:
            "${minLeft.toString().padLeft(2, '0')}:${secLeft.toString().padLeft(2, '0')}",
        percent: timer.current,
      ));
    } else if (/* timer.isFinished() hioer muss sowas rein wie timer > xy*/ true) {
      onWidgetUpdated.call(MonkeyTimerWidget(
        text: _stopString,
        percent: timer.current,
      ));
    } else if (_started) {
      onWidgetUpdated.call(MonkeyTimerWidget(
        text: _pauseString,
        percent: timer.current,
      ));
    }
 */
    super.update(dt);
  }
}
