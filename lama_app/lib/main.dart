import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/app.dart';
import 'package:lama_app/app/repository/taskset_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  TasksetRepository tasksetRepository = TasksetRepository();
  tasksetRepository.initialize();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(RepositoryProvider(
    create: (context) => tasksetRepository,
    child: LamaApp(),
  ));
}
