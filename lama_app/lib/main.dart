import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lama_app/app/app.dart';
import 'package:lama_app/app/repository/server_repository.dart';
import 'package:lama_app/app/repository/taskset_repository.dart';
import 'package:lama_app/app/screens/admin_menu_folder/taskset_manage/bloc/taskset_manage_bloc.dart';
import 'package:lama_app/app/task-system/subject_grade_relation.dart';
import 'package:lama_app/app/task-system/taskset_model.dart';

///Main method that launches the app.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ServerRepository serverRepository = ServerRepository();
  serverRepository.initialize();
  //initialize hive database
  if (kIsWeb) {
    await Hive.initFlutter();
    print("WEB Enabled: => Hive initiated");
  }
  TasksetRepository tasksetRepository = TasksetRepository();
  tasksetRepository.initialize(serverRepository);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await precacheSvgs();
  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider(
        create: (context) => tasksetRepository,
      ),
      RepositoryProvider(
        create: (context) => serverRepository,
      ),
    ],
    child: BlocProvider(
      create: (context) => TasksetManageBloc(
        allTaskset: taskset(tasksetRepository.tasksetLoader.loadedTasksets),
        tasksetPool: taskset(tasksetRepository.tasksetLoader.tasksetPool),
      ),
      child: LamaApp(),
    ),
  ));
}

List<Taskset> taskset(
    Map<SubjectGradeRelation, List<Taskset>> tasksetGradeKorrelation) {
  List<Taskset> list = [];
  tasksetGradeKorrelation.forEach((key, value) => list.addAll(value));
  print(list);
  return list;
}

///Precaches the svgs files.
///
///Especially important for the "MoneyTask" since the svgs would need
///a second to load otherwise which looks cheap and unprofessional.
Future<List<void>> precacheSvgs() async {
  return Future.wait([
    precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder,
          'assets/images/svg/EuroCoins/1_Cent.svg'),
      null,
    ),
    precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder,
          'assets/images/svg/EuroCoins/2_Cent.svg'),
      null,
    ),
    precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder,
          'assets/images/svg/EuroCoins/5_Cent.svg'),
      null,
    ),
    precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder,
          'assets/images/svg/EuroCoins/10_Cent.svg'),
      null,
    ),
    precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder,
          'assets/images/svg/EuroCoins/20_Cent.svg'),
      null,
    ),
    precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder,
          'assets/images/svg/EuroCoins/50_Cent.svg'),
      null,
    ),
    precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder,
          'assets/images/svg/EuroCoins/1_Euro.svg'),
      null,
    ),
    precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder,
          'assets/images/svg/EuroCoins/2_Euro.svg'),
      null,
    ),
    precachePicture(
      ExactAssetPicture(
          SvgPicture.svgStringDecoder, 'assets/images/svg/lama_coin.svg'),
      null,
    ),
    precachePicture(
      ExactAssetPicture(
          SvgPicture.svgStringDecoder, 'assets/images/svg/lama_head.svg'),
      null,
    ),
  ]);
}
