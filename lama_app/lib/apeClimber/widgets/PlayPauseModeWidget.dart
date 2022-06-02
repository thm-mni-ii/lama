import 'package:flutter/material.dart';
import 'package:lama_app/util/LamaColors.dart';

/// This class is a [StatelessWidget] for displaying the play Mode Hud of Flappy lama
/// It needs the [onButtonPressed] [Function] to ensure its workability.
class PlayPauseModeWidget extends StatelessWidget {
  // true = pause icon / false = play icon
  final bool playMode;
  // This function will be called when button is pressed.
  final Function onButtonPressed;

  const PlayPauseModeWidget({
    @required this.onButtonPressed,
    @required this.playMode
  });

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
            padding: EdgeInsets.only(bottom: 80),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: LamaColors.mainPink.withOpacity(0.7),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5
                      ),
                    ),
                    child: Icon(
                      playMode ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 30.0,
                    ),
                    onPressed: () {
                      onButtonPressed?.call();
                    },
                  ),
                ])
        )
    );
  }
}