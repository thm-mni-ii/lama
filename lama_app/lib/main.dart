import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lama_app/app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(LamaApp());
}
