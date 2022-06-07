import 'package:flutter/material.dart';
import 'buttons/action_button.dart';
import 'tetrisGame.dart';

class UserInput extends StatelessWidget {
  final Function onActionButtonPressed;
  const UserInput(this.onActionButtonPressed);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: ActionButton(
                onActionButtonPressed,
                const Icon(Icons.rotate_left),
                LastButtonPressed.ROTATE_LEFT,
              ),
            ),
            Expanded(
              child: ActionButton(
                onActionButtonPressed,
                const Icon(Icons.rotate_right),
                LastButtonPressed.ROTATE_RIGHT,
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: ActionButton(
                onActionButtonPressed,
                const Icon(Icons.arrow_left),
                LastButtonPressed.LEFT,
              ),
            ),
            Expanded(
              child: ActionButton(
                onActionButtonPressed,
                const Icon(Icons.arrow_right),
                LastButtonPressed.RIGHT,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
