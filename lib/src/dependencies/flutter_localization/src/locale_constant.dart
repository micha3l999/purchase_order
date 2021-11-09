import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:purchase_order/src/my_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String prefSelectedLanguageCode = "SelectedLanguageCode";

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(prefSelectedLanguageCode, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(prefSelectedLanguageCode) ?? "en";
  return _locale(languageCode);
}

Locale _locale(String? languageCode) {
  return languageCode != null
      ? Locale(languageCode, '')
      : const Locale('en', 'es');
}

void changeLanguage(BuildContext context, String selectedLanguageCode) async {
  var _locale = await setLocale(selectedLanguageCode);
  //MyApp.setLocale(context, _locale);
}
