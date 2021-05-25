import 'package:flutter/material.dart';

/// This class is a [StatelessWidget] for displaying the pause Mode Hud of Flappy lama
/// It needs the [onPlayPressed] [Function] to ensure its workability.
class PauseMode extends StatelessWidget {
  final Function onPlayPressed;

  const PauseMode({
    @required this.onPlayPressed
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
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 30.0,
                    ),
                    onPressed: () {
                      onPlayPressed.call();
                    },
                  ),
                ])
        )
    );
  }
}