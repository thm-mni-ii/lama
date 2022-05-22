import 'package:flutter/material.dart';
import '../tetrisGame.dart';

class ActionButton extends StatelessWidget {
  final Function onClickedFunction;
  final Icon buttonIcon;
  final LastButtonPressed nextAction;

  const ActionButton(this.onClickedFunction, this.buttonIcon, this.nextAction);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: ElevatedButton(
          onPressed: () {
            onClickedFunction(nextAction);
          },
          child: buttonIcon,
          style: ElevatedButton.styleFrom(
            side:
                BorderSide(width: 1, color: Color.fromARGB(255, 196, 194, 194)),
          ),
        ),
      ),
    );
  }
}
