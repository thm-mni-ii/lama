import 'dart:convert';

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/create_admin_bloc.dart';
import 'package:lama_app/app/bloc/create_user_bloc.dart';
import 'package:lama_app/app/bloc/taskset_options_bloc.dart';
import 'package:lama_app/app/bloc/user_selection_bloc.dart';
import 'package:lama_app/app/bloc/userlist_url_bloc.dart';

import 'package:lama_app/app/event/check_screen_event.dart';
import 'package:lama_app/app/model/taskUrl_model.dart';
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/repository/lamafacts_repository.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/app/screens/create_admin_screen.dart';
import 'package:lama_app/app/screens/home_screen.dart';
import 'package:lama_app/app/screens/user_selection_screen.dart';
import 'package:lama_app/app/screens/welcome_screen.dart';
import 'package:lama_app/app/state/check_screen_state.dart';
import 'package:lama_app/app/task-system/taskset_validator.dart';
import 'package:lama_app/db/database_provider.dart';
import 'package:lama_app/util/input_validation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

///[Bloc] for the [CheckScreen]
///
/// * see also
///    [CheckScreen]
///    [CheckScreenEvent]
///    [CheckScreenState]
///    [Bloc]
///
/// Author: L.Kammerer
/// latest Changes: 14.07.2021

class CheckScreenBloc extends Bloc<CheckScreenEvent, CheckScreenState?> {
  CheckScreenBloc({CheckScreenState? initialState}) : super(initialState) {
    on<CheckForAdmin>((event, emit) async {
      emit(await _hasAdmin(event.context));
    });
    on<DSGVOAccepted>((event, emit) async {
      await _loadWelcome(event.context);
    });
    on<CreateAdminEvent>((event, emit) async {
      emit(await _navigator(event.context));
    });
    on<CreateGuestEvent>((event, emit) async {
      emit(await _createGuest(event.context));
    });
    on<LoadGuest>((event, emit) async {
      ///wait for tasks to load
      if (event.doWait) await Future.delayed(Duration(milliseconds: 2000));
      await _loadGuest(event.context, event.user);
    });
    on<LoadWelcomeScreen>((event, emit) async {
      await _loadWelcome(event.context);
    });
    on<InsertSetupEvent>((event, emit) async {
      emit(await _insertSetup(event.context));
      //emit(LoadSetup(_userlistUrl, _tasksetUrl));
    });
    on<SetupChangeUrl>((event, emit) async {
      _setupUrl = event.setupUrl;
      emit(ChangeUrl());
    });
    on<SetupErrorMessage>((event, emit) async {});
  }
  //used to update the setup url when needed
  String? _setupUrl;
  String? _userlistUrl;
  String? _tasksetUrl;
  //list of [User] parsed from the [_url]
  List<User>? _userList = [];

  ///(private)
  ///check if an admin is stored in the Database
  ///if there is no admin the user has to accept the DSGVO
  ///and the 'enableDefaultTaskset' is set to default value true in the [SharedPreferences]
  ///if there is an Admin stored in the Database [_navigateAdminExist] is used
  ///
  ///{@param} [BuildContext] as context
  Future<CheckScreenState> _hasAdmin(BuildContext context) async {
    List<User> userList = await DatabaseProvider.db.getUser();
    if (userList == null) return ShowDSGVO(await _loadDSGVO());
    //gets first user if its a guest
    for (User user in userList) {
      if (user.isAdmin!) {
        _navigateAdminExist(context);
        return AdminExist();
      } else if (user.isGuest!) {
        return HasGuest(context, user);
      }
    }
    //set [SharedPreferences]
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enableDefaultTaskset', true);
    return ShowDSGVO(await _loadDSGVO());
  }

  Future<void> _loadWelcome(BuildContext context) async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => CheckScreenBloc(),
            ),
            BlocProvider(
              create: (context) => TasksetOptionsBloc(),
            ),
            BlocProvider(
              create: (context) => UserlistUrlBloc(),
            ),
          ],
          child: WelcomeScreen(),
        ),
      ),
    );
  }

  ///(private)
  ///used if no admin exists to force the user to create an admin
  ///
  ///{@param} [BuildContext] as context
  Future<CheckScreenState> _navigator(BuildContext context) async {
    await _navigateNoAdmin(context);
    return ShowWelcome();
  }

  Future<CheckScreenState> _createGuest(BuildContext context) async {
    //load lama facts
    //create and push guest user into database
    User user = User(
      grade: 1,
      coins: 0,
      isAdmin: false,
      avatar: 'lama',
      name: "Gast",
      isGuest: true,
      password: "0",
    );
    await DatabaseProvider.db.insertUser(user);
    //load guest user

    //go to home screen with guest user
    //_loadGuest(context, user);
    return HasGuest(context, user);
  }

  Future<void> _loadGuest(BuildContext context, User user) async {
    UserRepository repository = UserRepository(user);
    LamaFactsRepository lamaFactsRepository = LamaFactsRepository();
    await lamaFactsRepository.loadFacts();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MultiRepositoryProvider(providers: [
                  RepositoryProvider<UserRepository>(
                      create: (context) => repository),
                  RepositoryProvider<LamaFactsRepository>(
                      create: (context) => lamaFactsRepository)
                ], child: HomeScreen())));
  }

  ///(private)
  ///loading DSGVO out of the asserts
  Future<String> _loadDSGVO() async {
    return await rootBundle.loadString('assets/md/DSGVO.md');
  }

  ///(private)
  ///navigate to [CreateAdminScreen] with await. If the [CreateAdminScreen] pops with out creating and admin
  ///the admin value is equal to null. If an admin is created the [CreateAdminScreen] return an [User] on pop
  ///so this function ends with [_navigateAdminExist]
  ///
  ///{@param} [BuildContext] as context
  Future<void> _navigateNoAdmin(BuildContext context) async {
    User? admin = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (BuildContext context) => CreateAdminBloc(),
          child: CreateAdminScreen(),
        ),
      ),
    );
    if (admin != null) _navigateAdminExist(context);
  }

  ///(private)
  ///used if an admin exist or is created navigats to [UserSelectionScreen]
  ///via [Navigator].pushReplacement
  ///
  ///{@param} [BuildContext] as context
  void _navigateAdminExist(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (BuildContext context) => UserSelectionBloc(),
          child: UserSelectionScreen(),
        ),
      ),
    );
  }

  ///(private)
  ///used to read the setup JSON and navigate to [UserSelectionScreen] or show
  ///an Error-Message if reaching the Url fails
  ///
  ///{@param} [BuildContext] to navigate
  Future<CheckScreenState> _insertSetup(BuildContext context) async {
    //check if JSON file is valid
    String? error = await InputValidation.inputUrlWithJsonValidation(_setupUrl);
    String? errorUserList;
    String? errorTaskset;
    Map<String, dynamic>? urls;

    //TO-DO: errorhandling
    if (error != null) {
      print(error);
      return SetupError(error);
    }
    //get the two URLs from the JSON file
    try {
      final response = await http.get(Uri.parse(_setupUrl!));
      urls = _parseUrls(jsonDecode(response.body));
    } on SocketException {
      print('Kritischer Fehler beim erreichen der URL!');
      return SetupError('Kritischer Fehler beim erreichen der URL!');
    }
    //load userlist through URL
    if (urls != null) {
      errorUserList =
          await InputValidation.inputUrlWithJsonValidation(urls['userListUrl']);
      errorTaskset =
          await InputValidation.inputUrlWithJsonValidation(urls['tasksetUrl']);
    }
    //load taskset through URL
    /* errorUserList != null ?  print(errorUserList) :  */
    if (errorTaskset != null && errorUserList != null) {
      print('Taskset error: $errorTaskset Userlist error: $errorUserList');
      return SetupError(
          'Taskset error: $errorTaskset Userlist error: $errorUserList');
    } else {
      _userlistUrl = urls!['userListUrl'];
      _tasksetUrl = urls['tasksetUrl'];
    }
    return LoadSetup(_userlistUrl, _tasksetUrl);
    /* try {
      final response = await http.get(Uri.parse(urls['userListUrl']!));
      _userList = _parseUserList(jsonDecode(response.body));
    } on SocketException {
      print('Kritischer Fehler beim erreichen der URL!');
    }
    _userList!.forEach((user) async {
      await DatabaseProvider.db.insertUser(user);
    });
    final response = await http.get(Uri.parse(urls!['tasksetUrl']!));
    //Check if URL is reachable
    if (response.statusCode == 200) {
      //Taskset validtion
      String? tasksetError =
          TasksetValidator.isValidTaskset(jsonDecode(response.body));
      if (tasksetError != null) {
        print(tasksetError);
      }
    }
    await DatabaseProvider.db.insertTaskUrl(TaskUrl(url: urls['tasksetUrl']));
    //if everything works, navigate to UserSelectionScreen
    _navigateAdminExist(context); */
  }

  ///parses URLS from the json file and checks if the urls are strings
  Map<String, dynamic>? _parseUrls(Map<String, dynamic> json) {
    if (!(json.containsKey('userListUrl') && json['userListUrl'] is String)) {
      print("Es wurde keine userlist url gefunden");
      return null;
    }
    if (!(json.containsKey('tasksetUrl') && json['tasksetUrl'] is String)) {
      print("Es wurde keine taskset url gefunden");
      return null;
    }

    return json;
  }

  List<User>? _parseUserList(Map<String, dynamic> userJson) {
    //Check if UserList "users" exist in the json file
    if (!(userJson.containsKey('users') && userJson['users'] is List)) {
      print(
          'Feld ("users": [...]) fehlt oder ist fehlerhaft! \n Hinweis: ("users": [NUTZER])');
      return null;
    }
    var userList = userJson['users'] as List?;
    if (userList == null || userList.length == 0) {
      print(
          'Feld ("users": [...]) darf nicht leer sein! \n Hinweis: ("users": [NUTZER])');
      return null;
    }
    for (int i = 0; i < userList.length; i++) {
      //Check if user is valid
      String? error = User.isValidUser(userList[i]);
      if (error != null) {
        print('\n Nutzer: (${i + 1})');
        return null;
      }
      //Add valid User to _userList
      _userList!.add(User.fromJson(userList[i]));
    }
    //return valid _userList to UI
    return _userList;
  }

  void _parseTaskset() {
    //Insert URL to Database
  }
}
