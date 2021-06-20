import 'package:flutter/material.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

/// This class is a [StatelessWidget] for displaying the play Mode Hud of Flappy lama
/// It needs the [onButtonPressed] [Function] to ensure its workability.
class MonkeyTimerWidget extends StatelessWidget {
  // text which gets displayed
  final String text;
  // relative percent
  final double percent;

  const MonkeyTimerWidget({
    @required this.text,
    @required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    Color color = LamaColors.blueAccent.withOpacity(0.7);

    return Padding(
        padding: EdgeInsets.only(top: 20),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
              height: 60,
              width: 100,
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 2),
                        blurRadius: 5,
                        color: LamaColors.black.withOpacity(0.5))
                  ]),
              child: Center(
                child: InkWell(
                    child: Text(
                      text,
                      style: LamaTextTheme.getStyle(fontSize: 25),
                    )
                ),
              )

          )
      )
    );
  }
}