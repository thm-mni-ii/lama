import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/repository/server_repository.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';

class ServerSettingsScreen extends StatefulWidget {
  const ServerSettingsScreen({Key? key}) : super(key: key);

  @override
  State<ServerSettingsScreen> createState() => _ServerSettingsScreenState();
}

class _ServerSettingsScreenState extends State<ServerSettingsScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _url = TextEditingController();
  TextEditingController _userName = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _port = TextEditingController();

  bool first = true;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size.width;
    final serverRepo = RepositoryProvider.of<ServerRepository>(context);

    if (first && serverRepo.serverSettings != null) {
      _url.text = serverRepo.serverSettings!.url;
      _userName.text = serverRepo.serverSettings!.userName;
      _password.text = serverRepo.serverSettings!.password;
      _port.text = serverRepo.serverSettings!.port.toString();

      first = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Server Einstellung",
          style: LamaTextTheme.getStyle(fontSize: 18),
        ),
        toolbarHeight: screenSize / 5,
        backgroundColor: LamaColors.bluePrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                /* for (var i = 0; i < 8; i++) {
                  DatabaseProvider.db.deleteTaskUrl(i);
                }
                serverRepo.serverSettings = null; */
                ServerSettings s = ServerSettings(
                  id: serverRepo.serverSettings?.id ?? 0,
                  port: int.parse(_port.text),
                  url: _url.text,
                  userName: _userName.text,
                  password: _password.text,
                );
                await serverRepo.setOrUpdate(s);
                print(serverRepo.serverSettings.toString());
                Navigator.pop(context);
              }
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(label: Text("Url")),
                controller: _url,
                validator: (String? text) {
                  if (text == null || text.isEmpty) {
                    return "Please give a url";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(label: Text("Port")),
                controller: _port,
                keyboardType: TextInputType.number,
                validator: (String? text) {
                  if (text == null || text.isEmpty) {
                    return "Please give a port";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(label: Text("Username")),
                controller: _userName,
                validator: (String? text) {
                  if (text == null || text.isEmpty) {
                    return "Please give a username";
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                //obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter password",
                  icon: Icon(Icons.lock),
                ),
                controller: _password,
                validator: (String? text) {
                  if (text == null || text.isEmpty) {
                    return "Please give a passwort";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
