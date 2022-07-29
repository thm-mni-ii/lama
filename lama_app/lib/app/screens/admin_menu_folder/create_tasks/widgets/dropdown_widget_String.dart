import 'package:flutter/material.dart';

class DropdownWidgetString extends StatefulWidget {
  final ValueChanged<String?> onChanged;
  final String? currentSelected;
  final String? hintText;
  final List<String> itemsList;

  DropdownWidgetString(
      {Key? key,
      this.currentSelected,
      required this.hintText,
      required this.itemsList,
      required this.onChanged})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => DropdownWidgetStringState();
}

class DropdownWidgetStringState extends State<DropdownWidgetString> {
  String? currentSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: DropdownButtonFormField<String>(
        hint: Text(widget.hintText.toString()),
        value: currentSelected,
        isDense: true,
        onChanged: (String? newValue) {
          setState(() {
            currentSelected = newValue;
          });
          widget.onChanged(newValue);
        },
        items: widget.itemsList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
