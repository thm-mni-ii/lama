import 'package:lama_app/db/database_provider.dart';

final String tableServer = "server_settings";

class ServerFields {
  static final String columnId = "serverSettingsId";
  static final String columnPort = "port";
  static final String columnUrl = "url";
  static final String columnUserName = "userName";
  static final String columnPassword = "password";
}

class ServerSettings {
  int id;
  String url;
  int port;
  String userName;
  String password;

  ServerSettings({
    required this.id,
    required this.url,
    required this.port,
    required this.userName,
    required this.password,
  });

  ServerSettings.fromJson(Map<String, dynamic> json)
      : id = json['serverSettingsId'],
        port = json['port'],
        url = json['url'],
        userName = json['userName'],
        password = json['password'];

  Map<String, dynamic> toJson() => {
        'serverSettingsId': id,
        'port': port,
        'url': url,
        'userName': userName,
        'password': password,
      };

  @override
  String toString() {
    return id.toString() +
        " " +
        "$port " +
        url +
        " " +
        userName +
        " " +
        password;
  }
}

class ServerRepository {
  // DB:
  //eintrag in db machen können /
  // db verändern wenn neue/andere werte gesetzt sind
  // werte im repo bei appstart initialisieren

  // Daten:
  // laden der urls auch die im repo beachten wenn nicht leer oder null
  // dateien auf server der url schreiben
  // + auch in die lokalen listen
  // bereits existierende dateien verändern -> editieren (auf dem server verändern)
  // -> veränderte datei namen oder klassen => datei löschen neue anlegen mit anderem pfad ".../klasse/name"

  ServerSettings? serverSettings;

  /// loads db values in url, username, password
  void initialize() async {
    serverSettings = await DatabaseProvider.db.getServerSettings();
  }

  Future<void> setOrUpdate(ServerSettings serverS) async {
    serverSettings = await DatabaseProvider.db.insertServerSettings(serverS);
  }
}
