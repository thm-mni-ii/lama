import 'package:flutter/material.dart';
import 'package:lama_app/util/LamaColors.dart';

/// This class is a [StatelessWidget] for displaying the play Mode Hud of Flappy lama
/// It needs the [onPausePressed] [Function] to ensure its workability.
class PlayModeButton extends StatelessWidget {
  final Function onButtonPressed;
  final bool playMode;

  const PlayModeButton({
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
                      primary: LamaColors.redAccent,
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