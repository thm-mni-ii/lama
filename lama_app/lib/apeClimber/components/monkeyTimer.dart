import 'package:flame/components/timer_component.dart';
import 'package:flame/time.dart';
import 'package:lama_app/apeClimber/widgets/monkeyTimerWidget.dart';

/// This class is [TimerComponent] to display and handle the game timer.
class MonkeyTimer extends TimerComponent {
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
  Function(MonkeyTimerWidget) onWidgetUpdated;
  /// This function gets called when the timer finished.
  Function(MonkeyTimerWidget) onFinished;

  MonkeyTimer(this.onFinished) : super(Timer(_seconds,
      callback: () {
        onFinished?.call(MonkeyTimerWidget(
          text: _endString,
          percent: 1,
        ));
      }));

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

  @override
  void update(double dt) {
    if (timer.isRunning()) {
      var secondsLeft = (_seconds - timer.current).ceil();
      // calculate the minutes left
      var minLeft = ((secondsLeft) ~/ 60).toInt();
      // calculate the seconds left
      var secLeft = (secondsLeft - (minLeft * 60)).ceil();
      // calls the onWidgetUpdated function
      onWidgetUpdated?.call(MonkeyTimerWidget(
        text: "${minLeft.toString().padLeft(2, '0')}:${secLeft.toString().padLeft(2, '0')}",
        percent: timer.current,
      ));
    } else if (timer.isFinished()) {
      onWidgetUpdated?.call(MonkeyTimerWidget(
        text: _stopString,
        percent: timer.current,
      ));
    } else if (_started) {
      onWidgetUpdated?.call(MonkeyTimerWidget(
        text: _pauseString,
        percent: timer.current,
      ));
    }

    super.update(dt);
  }
}