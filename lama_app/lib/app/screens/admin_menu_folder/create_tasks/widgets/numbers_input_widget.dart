import 'package:flutter/material.dart';

class NumberInputWidget extends StatefulWidget {
  final TextEditingController numberController;
  final String? labelText;
  final String? missingInput;
  final FormFieldValidator? validator;

  NumberInputWidget(
      {Key? key,
      required this.numberController,
      required this.missingInput,
      required this.labelText,
      this.validator})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => NumberInputWidgetState();
}

class NumberInputWidgetState extends State<NumberInputWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5),
      child: TextFormField(
        controller: widget.numberController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: widget.labelText,
        ),
        validator: (text) {
          if (text == null || text.isEmpty) {
            return widget.missingInput;
          }
          if (widget.validator != null) {
            widget.validator;
          }

          return null;
        },
        onSaved: (String? text) => widget.numberController.text = text!,
      ),
    );
  }
}
