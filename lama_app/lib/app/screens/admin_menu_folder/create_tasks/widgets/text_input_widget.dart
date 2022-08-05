import 'package:flutter/material.dart';

class TextInputWidget extends StatefulWidget {
  final TextEditingController textController;
  final String? labelText;

  TextInputWidget(
      {Key? key,
      required this.textController,
      required this.labelText})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => TextInputWidgetState();
}

class TextInputWidgetState extends State<TextInputWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5),
      child: TextFormField(
        controller: widget.textController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: widget.labelText,
        ),
        validator: (text) {
          if (text == null || text.isEmpty) {
            return "Eingabe fehlt";
          }
          return null;
        },
        onSaved: (String? text) => widget.textController.text = text!,
      ),
    );
  }
}
