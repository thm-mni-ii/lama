import 'package:flutter/material.dart';

class DynamicDoubleTextFormFields extends StatefulWidget {
  final List<TextEditingController> controllers1;
  final List<TextFormField> fields;
  DynamicDoubleTextFormFields(
      {Key? key, required this.controllers1, required this.fields})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => DynamicDoubleTextFormFieldsState();
}

class DynamicDoubleTextFormFieldsState extends State<DynamicDoubleTextFormFields> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text("Füge einen Begriff hinzu"),
          trailing: Icon(Icons.add),
          onTap: () {
            final TextEditingController controller = TextEditingController();
            final TextFormField textFormField = TextFormField(
              controller: controller,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                border: OutlineInputBorder(),
                labelText: "${widget.fields.length + 1}. Begriff",
              ),
            );
            setState(() {
              widget.controllers1.add(controller);
              widget.fields.add(textFormField);
            });
          },
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.fields.length,
          itemBuilder: (context, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width / 2,
                    margin: EdgeInsets.only(top: 20),
                    child: widget.fields[index]),
                Container(
                    margin: EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width / 5,
                    child:
                        IconButton(onPressed: () {}, icon: Icon(Icons.delete)))
              ],
            );
          },
        )
      ],
    );
  }
}
