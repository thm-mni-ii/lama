import 'package:flutter/material.dart';

/// This class is a [StatelessWidget] for displaying the play Mode Hud of Flappy lama
/// It needs the [onPausePressed] [Function] to ensure its workability.
class PlayMode extends StatelessWidget {
  final Function onPausePressed;

  const PlayMode({
    @required this.onPausePressed
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
                  IconButton(
                    icon:
                    Icon(
                      Icons.pause,
                      color: Colors.white,
                      size: 30.0,
                    ),
                    onPressed: () {
                      onPausePressed.call();
                    },
                  ),
                ])
        )
    );
  }
}