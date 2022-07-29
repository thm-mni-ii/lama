import 'package:flutter/material.dart';

class LamacoinInputWidget extends StatefulWidget {
  final TextEditingController numberController;
  final FormFieldValidator? validator;

  LamacoinInputWidget(
      {Key? key,
      required this.numberController,
      this.validator})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => LamacoinInputWidgetState();
}

class LamacoinInputWidgetState extends State<LamacoinInputWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5),
      child: TextFormField(
        controller: widget.numberController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: "Gib die Anzahl der erreichbaren Lamacoins an",
        ),
        validator: (text) {
          if (widget.validator == null) {
            if (text == null || text.isEmpty) {
              return "Angabe fehlt";
            }
            return null;
          } else {
            widget.validator;
          }
          return null;
        },
        onSaved: (String? text) => widget.numberController.text = text!,
      ),
    );
  }
}