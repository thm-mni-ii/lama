import 'package:flutter/material.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/dynamic_doubleTextFormfield/two_controller.dart';
import 'package:lama_app/app/screens/admin_menu_folder/create_tasks/widgets/dynamic_doubleTextFormfield/two_textFields.dart';

class DynamicDoubleTextFormFields extends StatefulWidget {
  final List<TwoControllers> controllers;
  final List<TwoTextfields> fields;
  final String? labelText1;
  final String? labelText2;
  DynamicDoubleTextFormFields(
      {Key? key,
      required this.controllers,
      required this.fields,
      this.labelText1,
      this.labelText2})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => DynamicDoubleTextFormFieldsState();
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

class DynamicDoubleTextFormFieldsState
    extends State<DynamicDoubleTextFormFields> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text("Füge einen Begriff hinzu"),
          trailing: Icon(Icons.add),
          onTap: () {
            final TwoControllers controller = TwoControllers();
            final TextEditingController controller1 = TextEditingController();
            final TextEditingController controller2 = TextEditingController();
            controller.controller1 = controller1;
            controller.controller2 = controller2;
            final TwoTextfields textFormField = TwoTextfields(
              controller1: controller1,
              controller2: controller2,
              index: (widget.fields.length + 1),
              labelText1: widget.labelText1,
              labelText2: widget.labelText2,
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
