import 'package:flutter/material.dart';

class DynamicTextFormFields extends StatefulWidget {
  final List<TextEditingController> controllers;
  final List<TextFormField> fields;
  DynamicTextFormFields(
      {Key? key, required this.controllers, required this.fields})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => DynamicTextFormFieldsState();

  static loadListFromTask(List<TextEditingController> controllers,
      List<TextFormField> fields, List<String> listFromTask) {
    int controllersLength = listFromTask.length;
    print(controllersLength);
    for (int i = 0; i < controllersLength; i++) {
      controllers.add(TextEditingController(text: listFromTask[i]));

      fields.add(TextFormField(
        controller: controllers[i],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          border: OutlineInputBorder(),
          labelText: "${fields.length + 1}. Begriff",
        ),
      ));
    }
  }
}

class DynamicTextFormFieldsState extends State<DynamicTextFormFields> {
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
              widget.controllers.add(controller);
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
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          widget.controllers.removeAt(index);
                          widget.fields.removeAt(index);
                        });
                        print(widget.controllers.map((e) => e.text).toString());
                      },
                      icon: Icon(Icons.delete),
                    ))
              ],
            );
          },
        )
      ],
    );
  }
}
