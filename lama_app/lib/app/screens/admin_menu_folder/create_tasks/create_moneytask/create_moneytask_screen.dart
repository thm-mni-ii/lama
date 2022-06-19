import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_taskset_bloc.dart';
import 'package:lama_app/app/screens/admin_menu_folder/widgets/custom_appbar.dart';
import 'package:lama_app/app/task-system/task.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';
import 'package:lama_app/util/LamaColors.dart';


class MoneyEinstellenScreen extends StatefulWidget {
  @override
  MoneyEinstellenScreenState createState() => MoneyEinstellenScreenState();
}

class MoneyEinstellenScreenState extends State<MoneyEinstellenScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double von;
  double bis;
  int reward;

  @override
  void initState() {
    super.initState();
  }


   @override
  Widget build(BuildContext context) {
    Taskset blocTaskset = BlocProvider.of<CreateTasksetBloc>(context).taskset;
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppbar(
        size: screenSize.width/5,
        titel: "MoneyTask",
        color: LamaColors.findSubjectColor(blocTaskset.subject ?? "normal"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Geldbetrag",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 15, bottom: 15, right: 30),
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 30),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Von',
                            ),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return "Beitrag fehlt!";
                              }
                              return null;
                            },
                            onSaved: (text) {
                              von = double.parse(text);
                            },
                            onChanged: (text) =>
                                setState(() => this.von = double.parse(text)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 30),
                          child: Text(
                            "bis",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 30),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Bis',
                            ),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return "Beitrag fehlt!";
                              }
                              return null;
                            },
                            onSaved: (text) {
                              bis = double.parse(text);
                            },
                            onChanged: (text) =>
                                setState(() => this.bis = double.parse(text)),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
/*             Container(
              margin: EdgeInsets.only(top: 15, bottom: 15),
              child: ExpansionPanelList.radio(
                expansionCallback: (int index, bool isExpanded) {},
                children: _data.map<ExpansionPanelRadio>((Item item) {
                  return ExpansionPanelRadio(
                      value: item.id,
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          title: Text(item.headerValue),
                        );
                      },
                      body: CheckboxListTile(
                        title: Text("Nur volle Euro"),
                        onChanged: (bool value) {
                          setState(() {
                          });
                        },
                      ));
                }).toList(),
              ),
            ), */
            Container(
              margin: EdgeInsets.only(top: 30),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Erreichbare Lamacoins',
                ),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return "Beitrag fehlt!";
                  }
                  return null;
                },
                onSaved: (text) {
                  this.reward = int.parse(text);
                },
                onChanged: (text) => setState(() => this.reward = int.parse(text)),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.all(50),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MoneyEinstellenScreen()),
                        );
                        /*   if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Processing Data')),
                                );
                              }
                              _formKey.currentState?.save();
                              print(tasksetName);
                              print(kurzBeschreibung);
                              print(value);
                              print(value2); */
                      },
                      child: Text.rich(
                        TextSpan(
                            text: 'Preview',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        //TODO: bloc und event
                        TaskMoney moneyTask = TaskMoney("MoneyTask", this.reward, "", 3, von, bis);
                        Taskset taskset = BlocProvider.of<CreateTasksetBloc>(context).taskset;
                        taskset.tasks.add(moneyTask);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text.rich(
                        TextSpan(
                            text: 'Hinzufügen',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    )
                  ]),
            )
          ],
        ),
      ),
    );
  } 

  Widget _customBoldText(String text) {
    return Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
  }
}

class Item {
  Item({
    @required this.id,
    @required this.expandedValue,
    @required this.headerValue,
  });

  int id;
  String expandedValue;
  String headerValue;
}

List<Item> generateItems(int numberOfItems) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      id: index,
      headerValue: 'Erweiterte Optionen',
      expandedValue: "Nur volle Euro",
    );
  });
}