import 'package:flutter/material.dart';

class PlayMode extends StatelessWidget {
  final Function onPausePressed;

  const PlayMode({
    @required this.onPausePressed
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      ]);
  }
}