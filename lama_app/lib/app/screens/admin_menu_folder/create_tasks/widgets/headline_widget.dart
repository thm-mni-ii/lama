import 'package:flutter/cupertino.dart';

class HeadLineWidget extends StatelessWidget {
  late String text;

  HeadLineWidget(this.text);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30, left: 5, right: 5),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
