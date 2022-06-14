import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../util/LamaColors.dart';
import '../../../util/LamaTextTheme.dart';
import '../../bloc/user_selection_bloc.dart';
import '../user_selection_screen.dart';

class MoneyEinstellenScreen extends StatefulWidget {
  @override
  MoneyEinstellenScreenState createState() => MoneyEinstellenScreenState();
}

class MoneyEinstellenScreenState extends State<MoneyEinstellenScreen> {
  final List<Item> _data = generateItems(1);
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? von;
  String? bis;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: navBar(screenSize.width / 5, "Tasksets erstellen",
          LamaColors.bluePrimary) as PreferredSizeWidget?,
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
                              von = text;
                            },
                            onChanged: (text) =>
                                setState(() => this.von = text),
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
                              von = text;
                            },
                            onChanged: (text) =>
                                setState(() => this.bis = text),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            Container(
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
                        onChanged: (bool? value) {
                          setState(() {
                            timeDilation = value! ? 10.0 : 1.0;
                          });
                        },
                        value: timeDilation != 1.0,
                      ));
                }).toList(),
              ),
            ),
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
                  von = text;
                },
                onChanged: (text) => setState(() => this.von = text),
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

  Widget navBar(double size, String titel, Color colors) {
    return AppBar(
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (BuildContext context) => UserSelectionBloc(),
                    child: UserSelectionScreen(),
                  ),
                ),
              );
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ),
      title: Text(
        titel,
        style: LamaTextTheme.getStyle(fontSize: 18),
      ),
      toolbarHeight: size,
      backgroundColor: colors,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
    );
  }
}

class Item {
  Item({
    required this.id,
    required this.expandedValue,
    required this.headerValue,
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
