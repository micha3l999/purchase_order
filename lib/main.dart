import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchase_order/src/dependencies/shared_preferences/shared_preferences_keys.dart';
import 'package:purchase_order/src/dependencies/shared_preferences/shared_preferences_repo.dart';
import 'package:purchase_order/src/models/user_instance.dart';
import 'package:purchase_order/src/my_app.dart';
import 'package:purchase_order/src/network/api_base_routes.dart';
import 'package:purchase_order/src/network/api_instance.dart';
import 'package:purchase_order/src/routes/routes.dart';
import 'package:purchase_order/src/ui/login/models/user.dart';

void main() async {
  // Initialize
  WidgetsFlutterBinding.ensureInitialized();

  List<dynamic> futures = await Future.wait([
    SharedPreferencesRepo.getPrefer(SharedPreferencesKeys.user),
    SharedPreferencesRepo.getPrefer(SharedPreferencesKeys.ipConnection),
  ]);
  // Get userData saved in preferences
  String? userString = futures[0];
  String? connectionType = futures[1];
  Widget myApp;
  if (connectionType == "REMOTE") {
    ApiInstance.getInstance(true);
  } else {
    ApiInstance.getInstance();
  }
  if (userString != null) {
    User userData = User.fromJson(jsonDecode(userString));
    UserInstance.getInstance(userData.name, userData.code);
    myApp = const MyApp(
      initialWidget: Routes.home,
    );
  } else {
    myApp = const MyApp();
  }

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(myApp);
  });
}
