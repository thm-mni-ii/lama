import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final Function onClickedFunction;

  const MenuButton(this.onClickedFunction); //, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 200,
      minWidth: 200,
      child: ElevatedButton(
        onPressed: () {
          onClickedFunction();
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.lightGreen,
          textStyle: const TextStyle(fontSize: 20),
        ),
        //color: Colors.red,
        child: const Text('Start'),
      ),
    );
  }
}
