import 'package:flame/components/timer_component.dart';
import 'package:flame/time.dart';
import 'package:lama_app/apeClimber/widgets/monkeyTimerWidget.dart';

class MonkeyTimer extends TimerComponent {
  // SETTINGS
  // --------
  /// string which gets displayed of the widget when timer finished.
  static const _endString = "Ende";
  /// seconds the timer will run
  static const _seconds = 12.0;
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
      // calculate the minutes left
      var minLeft = (_seconds - timer.current) ~/ 60;
      // calculate the seconds left
      var secLeft = _seconds - timer.current - (minLeft * 60);
      // calls the onWidgetUpdated function
      onWidgetUpdated?.call(MonkeyTimerWidget(
        text: "${minLeft.toString().padLeft(2, '0')}:${secLeft.toStringAsFixed(0).padLeft(2, '0')}",
        percent: timer.current,
      ));
    } else if (timer.isFinished()) {
      onWidgetUpdated?.call(MonkeyTimerWidget(
        text: "Stop",
        percent: timer.current,
      ));
    } else if (_started) {
      onWidgetUpdated?.call(MonkeyTimerWidget(
        text: "Pause",
        percent: timer.current,
      ));
    }

    super.update(dt);
  }
}