import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchase_order/src/dependencies/shared_preferences/shared_preferences_keys.dart';
import 'package:purchase_order/src/dependencies/shared_preferences/shared_preferences_repo.dart';
import 'package:purchase_order/src/models/user_instance.dart';
import 'package:purchase_order/src/my_app.dart';
import 'package:purchase_order/src/routes/routes.dart';
import 'package:purchase_order/src/ui/login/models/user.dart';

void main() async {
  // Initialize
  WidgetsFlutterBinding.ensureInitialized();

  // Get userData saved in preferences
  String? userString =
      await SharedPreferencesRepo.getPrefer(SharedPreferencesKeys.user);
  Widget myApp;
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
