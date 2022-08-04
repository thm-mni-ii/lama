import 'package:flutter/material.dart';

class TwoTextfields extends StatefulWidget {
  TextEditingController? controller1;
  TextEditingController? controller2;
  String? labelText1;
  String? labelText2;
  int? index;

  TwoTextfields({
    required this.controller1,
    required this.controller2,
    required this.index,
    this.labelText1,
    this.labelText2,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TwoTextfieldState();
}

class TwoTextfieldState extends State<TwoTextfields> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        TextFormField(
          controller: widget.controller1,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            border: OutlineInputBorder(),
            labelText: widget.labelText1,
          ),
        ),
        TextFormField(
          controller: widget.controller2,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            border: OutlineInputBorder(),
            labelText: widget.labelText2,
          ),
        )
      ]),
    );
  }
}
