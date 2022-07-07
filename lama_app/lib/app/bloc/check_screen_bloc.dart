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
import 'package:lama_app/app/model/user_model.dart';
import 'package:lama_app/app/repository/lamafacts_repository.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/app/screens/create_admin_screen.dart';
import 'package:lama_app/app/screens/home_screen.dart';
import 'package:lama_app/app/screens/user_selection_screen.dart';
import 'package:lama_app/app/state/check_screen_state.dart';
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
      emit(await _loadWelcome(event.context));
    });
    on<CreateAdminEvent>((event, emit) async {
      emit(await _navigator(event.context));
    });
    on<CreateGuestEvent>((event, emit) async {
      emit(await _createGuest(event.context));
    });
    on<LoadGuest>((event, emit) async {
      ///wait for tasks to load
      await Future.delayed(Duration(milliseconds: 2000));
      await _loadGuest(event.context, event.user);
    });
    on<InsertSetupEvent>((event, emit) async {
      await _insertSetup(event.context);
    });
    on<SetupChangeUrl>((event, emit) async {
      _setupUrl = event.setupUrl;
    });
  }
  //used to update the setup url when needed
  String? _setupUrl;

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

  Future<CheckScreenState> _loadWelcome(BuildContext context) async {
    return ShowWelcome();
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
  ///used to read the setup JSON and navigateto [UserSelectionScreen]
  ///
  ///{@param} [BuildContext] to navigate
  Future<void> _insertSetup(BuildContext context) async {
    //check if JSON file is valid
    String? error = await InputValidation.inputUrlWithJsonValidation(_setupUrl);
    Map<String, String>? urls;
    /* if (error != null) return UserlistUrlParsingFailed(error: error); */
    //get the two URLs from the JSON file
    try {
      final response = await http.get(Uri.parse(_setupUrl!));
      urls = _parseUrls(jsonDecode(response.body));
    } on SocketException {
      /* return UserlistUrlParsingFailed(
        error: 'Kritischer Fehler beim erreichen der URL!',
      ); */
    }
    //load userlist through URL
    if (urls != null) {
      await InputValidation.inputUrlWithJsonValidation(urls['userlistUrl']);
      await InputValidation.inputUrlWithJsonValidation(urls['tasksetUrl']);
    }
    //load taskset through URL

    //if everything works, navigate to UserSelectionScreen
    _navigateAdminExist(context);
  }

  ///parses URLS from the json filem checks if the urls are strings
  Map<String, String>? _parseUrls(Map<String, String> json) {
    if (!(json.containsKey('userlistUrl') && json['userlistUrl'] is String)) {
      print("Es wurde keine userlist url gefunden");
      return null;
    }
    if (!(json.containsKey('tasksetUrl') && json['tasksetUrl'] is String)) {
      print("Es wurde keine taskset url gefunden");
      return null;
    }

    return json;
  }
}
