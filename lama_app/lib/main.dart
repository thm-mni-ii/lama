import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lama_app/app/app.dart';
import 'package:lama_app/app/task-system/taskset_loader.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  TasksetLoader().loadAllTasksets();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(LamaApp());
}
