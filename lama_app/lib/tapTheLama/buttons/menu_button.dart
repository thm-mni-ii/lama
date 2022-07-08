import 'package:flutter/material.dart';
import 'package:lama_app/util/LamaColors.dart';

class MenuButton extends StatelessWidget {
  final Function onClickedFunction;

  const MenuButton(this.onClickedFunction);

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
          primary: Color(0xffc283f5),
          textStyle: const TextStyle(fontSize: 20),
        ),
        //color: Colors.red,
        child: const Text('Start'),
      ),
    );
  }
}
