import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberInputWidget extends StatefulWidget {
  final TextEditingController numberController;
  final String? labelText;
  final Function(String)? validator;

  NumberInputWidget(
      {Key? key,
      required this.numberController,
      required this.labelText,
      this.validator})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => NumberInputWidgetState();
}

// class allows only int numbers, see inputformatters

class NumberInputWidgetState extends State<NumberInputWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5),
      child: TextFormField(
        controller: widget.numberController,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        decoration: InputDecoration(
          labelText: widget.labelText,
        ),
        validator: (text) {
          if (text == null || text.isEmpty) {
            return "Eingabe fehlt";
          }
          if (widget.validator == null) {
            return null;
          }
          return widget.validator!(text);
        },
        onSaved: (String? text) => widget.numberController.text = text!,
      ),
    );
  }
}
